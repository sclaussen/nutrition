import SwiftUI
import HealthKit


struct MealList: View {

    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var mealIngredientMgr: MealIngredientMgr
    @EnvironmentObject var adjustmentMgr: AdjustmentMgr
    @EnvironmentObject var macrosMgr: MacrosMgr
    @EnvironmentObject var profileMgr: ProfileMgr
    @EnvironmentObject var foodMgr: FoodMgr
    @EnvironmentObject var foodCompositeMgr: FoodCompositeMgr

    // Non-nil while the group member-picker sheet is shown.
    @State private var memberPickerFor: MealIngredient? = nil
    // Non-nil while the composite editor sheet is shown.
    @State private var compositeEditorFor: MealIngredient? = nil

    // Both toggles intentionally non-persistent — supplements default
    // hidden on every launch (you only enable them when you want to look),
    // and inactive items behave the same way.
    @State private var showInactive: Bool = false
    // When the eye toggle flips ON, this captures the names of rows
    // that were inactive at that moment. While showInactive is true,
    // the list is filtered to ONLY this snapshot — so activating a
    // row from the snapshot doesn't make it vanish from the list
    // (you keep seeing it until you toggle the eye off). Cleared
    // when the eye goes back off.
    @State private var inactiveSnapshot: Set<String> = []
    @State private var showSupplements: Bool = false
    @State var amount: Double = 0
    @State var mealConfigureActive = false
    @State var resetMealIngredientsAlert = false
    @State private var showSummary = false
    @State private var detailFor: MealIngredient? = nil
    @State private var entrySheetFor: MealIngredient? = nil
    @State private var vmListActive = false
    // Non-nil when a meat row is double-tapped — drives the proteins
    // editor sheet. Item-based rather than bool-based so SwiftUI
    // can present and dismiss cleanly off the same source of truth.
    @State private var proteinsEditorActive: Bool = false

    // ============================================================
    // LLM scanner state — mirrors IngredientList's wiring so the
    // camera works identically from the Meal page. Capture sheet →
    // ScanRoute → push prefilled Add/Edit (hidden NavigationLink) or
    // present the ambiguous-match chooser.
    // ============================================================
    @State private var showCaptureSheet = false
    @State private var costDetailActive = false
    @State private var scanAddPrefill: ParsedIngredient? = nil
    @State private var scanEditBundle: ScanEditBundle? = nil
    @State private var scanChooser: ScanChooserPayload? = nil

    private var scanAddActive: Binding<Bool> {
        Binding(get: { scanAddPrefill != nil },
                set: { if !$0 { scanAddPrefill = nil } })
    }
    private var scanEditActive: Binding<Bool> {
        Binding(get: { scanEditBundle != nil },
                set: { if !$0 { scanEditBundle = nil } })
    }

    struct ScanEditBundle {
        let existing: Ingredient
        let parsed: ParsedIngredient
        let diff: ScanDiff
    }
    struct ScanChooserPayload: Identifiable {
        let parsed: ParsedIngredient
        let candidates: [Ingredient]
        var id: String { parsed.name }
    }

    private func applyScanRoute(_ route: ScanRoute) {
        switch route {
        case .new(let parsed):
            scanAddPrefill = parsed
        case .update(let existing, let parsed, let diff):
            scanEditBundle = ScanEditBundle(existing: existing, parsed: parsed, diff: diff)
        case .chooser(let parsed, let candidates):
            scanChooser = ScanChooserPayload(parsed: parsed, candidates: candidates)
        }
    }

    // Use cases:
    // - Deactivate a meal ingredient because it's out that will be auto-adjusted
    //
    // Actions:
    // - Manually updating amount removes the pending compensation if it exists
    var body: some View {
        List {
            // Dashboard moved out of the List and into the .safeAreaInset
            // header below so the toolbar+macros+calories area is fixed
            // and never scrolls with the meal rows.
            //
            // Ingredient / Amount column header removed — the row's
            // own affordances (name on the left, stepper + chevron on
            // the right) communicate the columns without a label row.

            ForEach(displayedMealIngredients()) { mealIngredient in
                // Row layout is strict proportional: name 50%, left
                // triangle 10%, pill 20%, right triangle 10%, chevron
                // 10%. Each segment's entire allocated width is its
                // tap zone (via contentShape) so taps on whitespace
                // adjacent to a symbol still hit the right control.
                GeometryReader { geo in
                    let w = geo.size.width
                    HStack(spacing: 0) {
                        // Just the name — IngredientRow is overkill here
                        // (its showMacros/showAmount are both off, and
                        // its inner GeometryReader+frame(height: 9) was
                        // glueing the text to the top of the 28pt row).
                        // Plain Text centers vertically via the HStack's
                        // default .center alignment, matching the
                        // stepper and chevron.
                        if mealIngredient.isComposite {
                            // Composite row: long-press opens the
                            // dedicated multi-component editor (too
                            // complex for an inline dropdown). Single
                            // tap still cycles the lock state.
                            mealNameLabel(mealIngredient)
                              .frame(width: w * 0.50, alignment: .leading)
                              .contentShape(Rectangle())
                              .onLongPressGesture {
                                  compositeEditorFor = mealIngredient
                              }
                              .onTapGesture {
                                  toggleLock(mealIngredient)
                              }
                        } else {
                            mealNameLabel(mealIngredient)
                              .frame(width: w * 0.50, alignment: .leading)
                              // contentShape makes the full 50% zone hit-
                              // testable, not just the rendered glyphs.
                              .contentShape(Rectangle())
                              // Double-tap on a meat row opens the proteins
                              // editor. Single-tap goes through the same
                              // Auto/Manual/Done cycle as every other
                              // row — meat is no longer special-cased
                              // beyond the double-tap addition.
                              .if(mealIngredient.meat) { view in
                                  view.onTapGesture(count: 2) {
                                      proteinsEditorActive = true
                                  }
                              }
                              // Group rows: long-press immediately opens
                              // the variant picker (confirmationDialog
                              // below). Lock stays on the single-tap
                              // cycle.
                              .if(isGroupRow(mealIngredient)) { view in
                                  view.onLongPressGesture {
                                      memberPickerFor = mealIngredient
                                  }
                              }
                              .onTapGesture {
                                  toggleLock(mealIngredient)
                              }
                        }
                        if mealIngredient.isComposite {
                            // Composites have no single amount; the
                            // stepper slot shows the summed calories
                            // and opens the component editor on tap.
                            Button {
                                compositeEditorFor = mealIngredient
                            } label: {
                                Text("\(Int(mealIngredient.calories)) cals")
                                  .font(.callout)
                                  .frame(width: w * 0.40, alignment: .center)
                                  .contentShape(Rectangle())
                            }
                              .buttonStyle(.borderless)
                        } else {
                            AmountStepper(
                            amount: mealIngredient.amount,
                            unit: getConsumptionUnit(mealIngredient.name),
                            // "Locked" here means Done (blue): inc/dec/pill
                            // are disabled. Manual rows (black) still allow
                            // amount changes; the stepper stays visible and
                            // active for those.
                            isLocked: mealIngredient.active && mealIngredient.adjustment == Constants.Done,
                            isAuto:   isInAutoMode(mealIngredient),
                            decrementWidth: w * 0.10,
                            pillWidth:      w * 0.20,
                            incrementWidth: w * 0.10,
                            onDecrement:       { stepAmount(mealIngredient, direction: -1) },
                            onIncrement:       { stepAmount(mealIngredient, direction: +1) },
                            // Hold the ◀ triangle: zero the amount AND
                            // lock the row (Done / blue) in one shot.
                            // doneAdjustment(…, amount: 0) sets both,
                            // so the row immediately renders as the
                            // locked "0 <unit>" blue pill and stops
                            // being auto-adjusted. Same lock path as
                            // the Black → Blue tap-name transition.
                            onDecrementToZero: {
                                mealIngredientMgr.doneAdjustment(name: mealIngredient.name, amount: 0)
                                generateMeal()
                            },
                            onPillTap:         { entrySheetFor = mealIngredient }
                            )
                        }

                        Button {
                            detailFor = mealIngredient
                        } label: {
                            Image(systemName: "chevron.right")
                              .font(.caption2)
                              // Glyph sits at the right edge (alignment:
                              // .trailing) but the whole 10% zone stays
                              // tappable because contentShape covers
                              // the full frame.
                              .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                              .contentShape(Rectangle())
                        }
                          .buttonStyle(.borderless)
                          .foregroundColor(Color.theme.blackWhiteSecondary)
                          .frame(width: w * 0.10)
                    }
                      // Color tells you which mode the row is in:
                      //   Red    — inactive
                      //   Green  — Auto mode: either Automatic (was just
                      //            auto-adjusted) OR Default with an
                      //            adjustment rule targeting it (auto-
                      //            eligible, may not have fired this
                      //            cycle if macros are full)
                      //   Blue   — Done (Constants.Done)
                      //   Black  — Manual, or Default without an auto-rule
                      .foregroundColor(!mealIngredient.active ? Color.theme.red :
                                        (isInAutoMode(mealIngredient) ? Color.theme.manual :
                                           (mealIngredient.adjustment == Constants.Done ? Color.theme.blueYellow :
                                              Color.theme.blackWhite)))
                }
                  // Explicit row height — GeometryReader has no intrinsic
                  // height inside a List row, so without this the row
                  // would collapse. 26.6pt = 28 × 0.95 (5% reduction).
                  .frame(height: 26.6)

                  // Swipe-trailing — single button that flips the row
                  // to inactive (active = false). It doesn't delete
                  // the meal ingredient; the row just moves out of
                  // the active view and is reachable again via the
                  // eye (inactive-snapshot) toggle.
                  //
                  // Suppressed in two cases (be defensive but minimal):
                  //   * snapshot view (eye on) — that mode is for
                  //     re-activating; swipe-to-deactivate doesn't
                  //     belong there.
                  //   * row is already inactive — no-op, would just
                  //     confuse.
                  // minus.circle.fill mirrors IngredientList's
                  // "Unlist" affordance (minus.circle) — same family.
                  .swipeActions(edge: .trailing) {
                      if !showInactive && mealIngredient.active {
                          Button(role: .destructive) {
                              _ = mealIngredientMgr.toggleActive(mealIngredient)
                              generateMeal()
                          } label: {
                              Label("Inactive", systemImage: "minus.circle.fill")
                          }
                      }
                  }
            }
              // .onMove(perform: moveAction)
              .onDelete(perform: deleteAction)
              .border(Color.theme.green, width: 0)
              // Compressed vertical insets — fits more ingredients per
              // screen without shrinking the content fonts themselves.
              // Horizontal insets define the row's usable width that
              // GeometryReader sees, which then splits into the
              // 50 / 10 / 20 / 10 / 10 segments above.
              .listRowInsets(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
        }
          // Plain list style + an explicit grey background eliminates
          // .insetGrouped's mandatory ~35pt section padding above the
          // first row and below the last.  Combined with the fixed
          // safeAreaInset header below, the meal rows now scroll under
          // a stationary grey "card" without any iOS-injected gaps.
          .listStyle(.plain)
          .background(Color(UIColor.systemGroupedBackground))
          .hiddenScrollBackground()
          .refreshable {
              generateMeal()
          }
          .environment(\.defaultMinListRowHeight, 5)
          // Negative horizontal padding removed — that was a hack for
          // .insetGrouped's row insets.  With .plain style the rows now
          // extend full-width naturally; the negative padding was
          // pushing content past the screen edge and clipping the
          // ingredient names on the left and the chevron on the right.
          .background(
            NavigationLink(destination: MealConfigure(), isActive: $mealConfigureActive) {
                Label("Configure", systemImage: "gear")
            })
          // Hide the system navigation bar; replace it with a fixed
          // header (toolbar + Dashboard) injected via .safeAreaInset.
          // Everything in the inset is anchored to the top — it never
          // scrolls with the meal rows below, which was the user's
          // primary ask.
          .navigationBarHidden(true)
          .safeAreaInset(edge: .top, spacing: 0) {
              // Spacing 10 — doubles the prior ~10pt visible gap to
              // ~20pt between toolbar icons and the macro titles.
              VStack(spacing: 10) {

                  // ----- Custom compact toolbar -----
                  HStack(spacing: 0) {

                      // Reset (was the navigation-slot Edit button).
                      Button {
                          print("Reset button tapped — flipping alert binding to true")
                          resetMealIngredientsAlert = true
                      } label: {
                          Image(systemName: "arrow.uturn.backward")
                      }
                        .frame(width: 44)
                        .foregroundColor(Color.theme.blueYellow)

                      Spacer()

                      // Show inactive / show supplements / V&M list.
                      // Eye on  → list = the snapshot of names that
                      //   were inactive at the moment of toggle. Stays
                      //   stable as user activates entries.
                      // Eye off → list = currently-active rows, snapshot
                      //   cleared.
                      Button {
                          if showInactive {
                              showInactive = false
                              inactiveSnapshot = []
                          } else {
                              inactiveSnapshot = Set(
                                  mealIngredientMgr.mealIngredients
                                    .filter { !$0.active }
                                    .map { $0.name }
                              )
                              showInactive = true
                          }
                      } label: {
                          Image(systemName: showInactive ? "eye.fill" : "eye")
                      }
                        .frame(width: 44)
                        .foregroundColor(showInactive ? Color.theme.blueYellow : Color.theme.blackWhiteSecondary)

                      // Fixed 18pt spacers between the middle three
                      // icons — roughly doubles the visible glyph-to-
                      // glyph gap (was ~18.5pt of empty room inside the
                      // 44pt frames; +18 makes it ~37pt).
                      Spacer().frame(width: 18)
                      Button {
                          showSupplements.toggle()
                      } label: {
                          Image(systemName: showSupplements ? "leaf.fill" : "leaf")
                      }
                        .frame(width: 44)
                        .foregroundColor(showSupplements ? Color.theme.blueYellow : Color.theme.blackWhiteSecondary)

                      Spacer().frame(width: 18)
                      Button {
                          vmListActive = true
                      } label: {
                          Image(systemName: "pills")
                      }
                        .frame(width: 44)
                        .foregroundColor(Color.theme.blueYellow)

                      Spacer().frame(width: 18)
                      // LLM scanner — rendered 50% larger than the
                      // other cluster glyphs (the inherited toolbar
                      // size is 25.5; 25.5 × 1.5 ≈ 38) since it's the
                      // primary action. Same scanner reachable from
                      // the Prep page's centered toolbar.
                      Button {
                          showCaptureSheet = true
                      } label: {
                          Image(systemName: "camera.viewfinder")
                            .font(.system(size: 34.2))
                      }
                        .frame(width: 56)
                        .foregroundColor(Color.theme.blueYellow)

                      Spacer().frame(width: 18)
                      // Meal cost breakdown — every meal ingredient
                      // sorted by its cost contribution (cost/gram ×
                      // grams consumed), most expensive first.
                      Button {
                          costDetailActive = true
                      } label: {
                          Image(systemName: "dollarsign.circle")
                      }
                        .frame(width: 44)
                        .foregroundColor(Color.theme.blueYellow)

                      Spacer()

                      // Settings (was the primaryAction Add link).
                      Button {
                          mealConfigureActive.toggle()
                      } label: {
                          Image(systemName: "gear")
                      }
                        .frame(width: 44)
                        .foregroundColor(Color.theme.blueYellow)
                  }
                    .font(.system(size: 22.95))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)

                  // ----- Dashboard (macros + calories bar) -----
                  // Pulled out of the List so it stays fixed at the top
                  // alongside the toolbar.
                  Dashboard(caloriesGoal: profileMgr.profile.caloriesGoal,
                            caloriesGoalUnadjusted: profileMgr.profile.caloriesGoalUnadjusted,
                            calories: macrosMgr.macros.calories,
                            fatGoal: profileMgr.profile.fatGoal,
                            netCarbsMaximum: profileMgr.profile.netCarbsMaximum,
                            proteinGoal: profileMgr.profile.proteinGoal,
                            fat: macrosMgr.macros.fat,
                            netCarbs: macrosMgr.macros.netCarbs,
                            protein: macrosMgr.macros.protein,
                            showSummary: $showSummary)
                    // Dropped 160 → 151pt — halves remaining grey
                    // space between the Goal/TDEE labels and the
                    // first meal row below.
                    .frame(height: 151)
              }
                // Single grey backdrop spans the whole fixed header
                // (toolbar + dashboard).  Same color as the List below,
                // so transitions are seamless.
                .background(Color(UIColor.systemGroupedBackground))
          }
          .onAppear {
              generateMeal()
          }
          .alert("Reset Meal Ingredients?",
                 isPresented: $resetMealIngredientsAlert) {
              Button("Cancel", role: .cancel) {
                  print("Reset alert: Cancel tapped")
              }
              Button("Reset", role: .destructive) {
                  print("Reset alert: Reset tapped — calling resetMealIngredients()")
                  mealIngredientMgr.resetMealIngredients()
                  generateMeal()
                  print("Reset alert: done. mealIngredients count = \(mealIngredientMgr.mealIngredients.count)")
              }
          } message: {
              Text("This will replace your current meal ingredient amounts with the defaults. This can't be undone.")
          }
          .sheet(isPresented: $showSummary) {
              DailySummary()
          }
          .sheet(isPresented: $costDetailActive) {
              NavigationView {
                  IngredientCostDetail()
                    .environmentObject(ingredientMgr)
                    .environmentObject(mealIngredientMgr)
                    .environmentObject(foodMgr)
              }
          }
          .sheet(item: $entrySheetFor) { mi in
              let unit = getConsumptionUnit(mi.name)
              NumberEntrySheet(
                  title: "\(mi.name) (\(unit.pluralForm))",
                  initialValue: mi.amount
              ) { newAmount in
                  applyAmount(mi, newAmount: newAmount)
              }
          }
          .sheet(item: $compositeEditorFor) { mi in
              CompositeEditor(
                  compositeName: mi.name,
                  parts: mi.compositeParts,
                  variants: { food in
                      ingredientMgr.getAll()
                        .filter { $0.foodName == food }
                        .map { $0.name }.sorted()
                  }
              ) { updated in
                  mealIngredientMgr.setCompositeParts(name: mi.name, parts: updated)
                  generateMeal()
              }
          }
          .sheet(isPresented: $proteinsEditorActive, onDismiss: {
              // Editor saves through profileMgr.setProteins which mutates
              // profile.proteins; rebuild the meal so the new protein
              // rows show up (or stale ones disappear). No-op on Cancel
              // since cancel doesn't touch profile.
              generateMeal()
          }) {
              ProteinsEditor()
          }
          // Long-press on a Food row opens this variant picker
          // immediately (no intermediate tap). Picking applies the
          // variant and becomes the Food's new default.
          .confirmationDialog(
              "Select variant",
              isPresented: Binding(
                  get: { memberPickerFor != nil },
                  set: { if !$0 { memberPickerFor = nil } }
              ),
              titleVisibility: .visible,
              presenting: memberPickerFor
          ) { mi in
              ForEach(groupMembers(mi), id: \.id) { m in
                  Button(!m.brand.isEmpty && !m.name.contains(m.brand)
                         ? "\(m.name) — \(m.brand)" : m.name) {
                      selectGroupMember(mi, member: m.name)
                      memberPickerFor = nil
                  }
              }
          }
          // Scanner — capture sheet, ambiguous-match chooser, and
          // hidden NavigationLinks that push prefilled Add/Edit.
          // Mirrors IngredientList so behavior is identical from
          // either page.
          .sheet(isPresented: $showCaptureSheet) {
              LabelCaptureSheet { route in
                  applyScanRoute(route)
              }
                .environmentObject(ingredientMgr)
          }
          .sheet(item: $scanChooser) { payload in
              MatchChooserSheet(parsed: payload.parsed,
                                candidates: payload.candidates) { resolved in
                  applyScanRoute(resolved)
              }
          }
          .background(
              Group {
                  NavigationLink(
                      destination: Group {
                          if let p = scanAddPrefill { IngredientAdd(prefill: p) }
                      },
                      isActive: scanAddActive
                  ) { EmptyView() }

                  NavigationLink(
                      destination: Group {
                          if let b = scanEditBundle {
                              IngredientEdit(ingredient: b.existing,
                                             prefill: b.parsed,
                                             diff: b.diff)
                          }
                      },
                      isActive: scanEditActive
                  ) { EmptyView() }
              }
          )
          .background(
              NavigationLink(
                  destination: Group {
                      if let mi = detailFor {
                          MealIngredientDetail(mealIngredient: mi)
                      }
                  },
                  isActive: Binding(
                      get: { detailFor != nil },
                      set: { if !$0 { detailFor = nil } }
                  )
              ) {
                  EmptyView()
              }
          )
          .background(
              NavigationLink(destination: VitaminMineralList(),
                             isActive: $vmListActive) {
                  EmptyView()
              }
          )
    }


    // Step the meal ingredient's amount by the ingredient's
    // effective step size.  Floors at 0.
    func stepAmount(_ mi: MealIngredient, direction: Double) {
        guard let ingredient = resolvedIngredient(mi) else { return }
        let delta = effectiveStep(for: ingredient, foodMgr: foodMgr) * direction
        let newAmount = max(0, mi.amount + delta)
        applyAmount(mi, newAmount: newAmount)
    }


    // Apply a new amount to the meal ingredient.  Meat ingredients
    // route through profileMgr (updating the matching Protein in the
    // profile.proteins list); everything else goes through
    // mealIngredientMgr.manualAdjustment so the change records as a
    // manual override and survives the next generateMeal.
    func applyAmount(_ mi: MealIngredient, newAmount: Double) {
        if mi.meat {
            profileMgr.setProteinAmount(name: mi.name, amount: newAmount)
        } else {
            mealIngredientMgr.manualAdjustment(name: mi.name, amount: newAmount)
        }
        generateMeal()
    }


    // Tap on the ingredient name cycles the row through its modes.
    // The transition is keyed off the row's visible color, not its
    // raw adjustment field — Default rows can render green (when
    // auto-eligible) so they need to behave like green rows do.
    //
    //   Auto-eligible:   Green → Black → Blue → (Green again)
    //   Manual-only:     Black → Blue → Black
    //
    // Special case: when the inactive-snapshot view is open (eye
    // on), tap-name is a plain active toggle (red ↔ black/colored).
    // The Auto/Manual/Done cycle is suspended in this mode so the
    // user can scan the inactive set and flip the ones they want
    // without juggling lock state.
    func toggleLock(_ mi: MealIngredient) {
        if showInactive {
            _ = mealIngredientMgr.toggleActive(mi)
            generateMeal()
            return
        }
        if isInAutoMode(mi) {
            // Green → Black: enter manual mode. Auto-adjust will
            // skip the row from here on. mi.amount captures whatever
            // auto-adjustment landed on (or the seeded amount if
            // auto hadn't fired this cycle).
            mealIngredientMgr.manualAdjustment(name: mi.name, amount: mi.amount)
        } else if mi.adjustment == Constants.Done {
            // Blue → Default. For auto-eligible ingredients, reset
            // amount to originalAmount so the next generateMeal can
            // re-promote cleanly. Manual-only ingredients keep the
            // user's amount.
            let isAutoEligible = adjustmentMgr.adjustments.contains { $0.name == mi.name }
            mealIngredientMgr.undoDoneAdjustment(name: mi.name, resetAmount: isAutoEligible)
        } else {
            // Black (Manual, or non-eligible Default) → Blue.
            mealIngredientMgr.doneAdjustment(name: mi.name, amount: mi.amount)
        }
        generateMeal()
    }


    // The list of rows the ForEach should render right now.
    //   Eye off → currently-active rows.
    //   Eye on  → exactly the rows the user could see when they
    //             flipped the eye on (the snapshot). Activating one
    //             keeps it in the snapshot, so it stays visible.
    // Supplement filter applies to both cases.
    func displayedMealIngredients() -> [MealIngredient] {
        let base: [MealIngredient]
        if showInactive {
            base = mealIngredientMgr.mealIngredients.filter { inactiveSnapshot.contains($0.name) }
        } else {
            base = mealIngredientMgr.mealIngredients.filter { $0.active }
        }
        // Supplement hide/show is unchanged — only the visible set is
        // affected.
        let visible = base.filter { showSupplements || !$0.isSupplement }
        // Ordered by the row's Food category (IngredientType.sortRank)
        // then name. Supplements naturally fall last (sortRank 7);
        // rows whose Food can't be resolved sort after that.
        return visible.sorted {
            let r0 = mealRowTypeRank($0)
            let r1 = mealRowTypeRank($1)
            return r0 != r1 ? r0 < r1 : $0.name < $1.name
        }
    }


    // The category rank for a meal row, resolved through its
    // ingredient's Food. Unresolvable rows sort last (Int.max).
    private func mealRowTypeRank(_ mi: MealIngredient) -> Int {
        guard let ing = resolvedIngredient(mi) else { return Int.max }
        return foodMgr.type(of: ing)?.sortRank ?? Int.max
    }


    // Is this row visually green? True when the row is active AND
    // either was actually auto-adjusted this cycle (Automatic) OR is
    // a Default row that has an Adjustment rule targeting it (auto-
    // eligible — auto may not have fired due to macro limits, but
    // the user's mental model is still "this row is in auto mode").
    func isInAutoMode(_ mi: MealIngredient) -> Bool {
        guard mi.active else { return false }
        if mi.adjustment == Constants.Automatic { return true }
        if mi.adjustment == Constants.Default {
            return adjustmentMgr.adjustments.contains { $0.name == mi.name }
        }
        return false
    }


    // func moveAction(from source: IndexSet, to destination: Int) {
    //     mealIngredientMgr.move(from: source, to: destination)
    // }


    func deleteAction(indexSet: IndexSet) {
        mealIngredientMgr.deleteSet(indexSet: indexSet)
    }


    func generateMeal() {

        print("\n\n\nGENERATE MEAL\n================================================================================\n")

        // Attempt to retrieve the body weight and body fat percentage
        // from Health Kit and update the profile if new values are
        // available.
        getBodyWeightAndBodyFatFromHealthKit()

        // Set (or reset) the daily macro goals:
        // - reflects any changes in the manually updated profile
        // - reflects any changes to the automatically updated profile fields
        macrosMgr.setDailyMacroGoals(caloriesGoalUnadjusted: profileMgr.profile.caloriesGoalUnadjusted, caloriesGoal: profileMgr.profile.caloriesGoal, fatGoal: profileMgr.profile.fatGoal, fiberMinimum: profileMgr.profile.fiberMinimum, netCarbsMaximum: profileMgr.profile.netCarbsMaximum, proteinGoal: profileMgr.profile.proteinGoal)

        // Undo all the auto adjustments (so we can reapply them
        // with a clean slate).  Removal will result in:
        // 1. Meal ingredients being deleted that were added as a result of apply adjustments
        // 2. Meal ingredient amounts being set to original values, and deativation
        mealIngredientMgr.undoAutoAdjustments()

        print("\nProtein Adjustments")
        mealIngredientMgr.reapplyProteins(profileMgr.profile.proteins)
        // Apply each protein's own mealAdjustments cascade. Today no
        // active protein declares any, but the loop generalizes when
        // we have multiple proteins so each one can contribute its
        // own auto-adjusted sidekicks.
        for protein in profileMgr.profile.proteins {
            guard let ingredient = ingredientMgr.getByName(name: protein.name) else { continue }
            for mealAdjustment in ingredient.mealAdjustments {
                guard let mealIngredient = mealIngredientMgr.getByName(name: mealAdjustment.name) else { continue }
                if mealIngredient.active {
                    mealIngredientMgr.automaticAdjustment(name: mealAdjustment.name, amount: mealAdjustment.amount)
                }
            }
        }

        // Initialize the total macros for each meal ingredient and
        // the total macros for all ingredients.  These will all be
        // updated later in this algorithm.
        mealIngredientMgr.setMacroActualsToZero()
        for mealIngredient in mealIngredientMgr.getActive(includeInactive: true) {
            setMacroActualsAndUpdateMealMacroActuals(mealIngredient.name, Double(mealIngredient.amount), mealIngredient.active)
        }

        print("\nAdding Automatic Adjustments")
        var failedCount = 0
        while failedCount < 10 {
            while tryAddingAdjustments() {
                failedCount = 0
            }
            failedCount += 1
        }
    }


    func tryAddingAdjustments() -> Bool {
        for adjustment in getAdjustmentOrder() {
            if tryAddingAdjustment(adjustment) {
                return true
            }
        }
        return false
    }


    // This algorithm is best described by example using an ordered
    // list of adjustments annotated with adjustment groups:
    //
    // adj adj-group
    // a   g1
    // b
    // c   g2
    // d   g1
    // e   g2
    // f   g1
    // g
    //
    // Will produce the following order of adjustments where the items
    // inside the [] are returned in a randomized order that may change
    // on each invocation of the algorithm:
    //
    // [a d f]* b [c e]* g
    // * in some random order
    //
    // Thus the following are potential orders returned:
    // f a d b e c g
    // d f a b c e g
    // a d f b c e g
    func getAdjustmentOrder() -> [Adjustment] {
        var adjustmentOrder: [Adjustment] = []
        var adjustmentGroupSeen: [String] = []

        for adjustment in adjustmentMgr.getAll() {

            // If the adjustment is not part of a group add it in the
            // order it was found
            if adjustment.group == "" {
                adjustmentOrder.append(adjustment)
                continue
            }

            // When the first adjustment in an adjustment group is
            // found, all subsequent adjustments in the adjustment
            // group are processed, so ignore them if we see them a
            // second time.
            if adjustmentGroupSeen.contains(adjustment.group) {
                continue
            }

            // All adjustments in the same adjustment group are added
            // to the adjustment order sequentially beginning with the
            // position of the first adjustment in the group, but
            // their order is randomized.
            adjustmentGroupSeen.append(adjustment.group)
            var groupedAdjustments: [Adjustment] = adjustmentMgr.adjustments.filter( { $0.group == adjustment.group })
            for _ in stride(from: groupedAdjustments.count, through: 1, by: -1) {
                let groupedAdjustment = groupedAdjustments.randomElement()
                adjustmentOrder.append(groupedAdjustment!)
                groupedAdjustments = groupedAdjustments.filter( { $0.name != groupedAdjustment!.name })
            }
        }

        return adjustmentOrder
    }


    func tryAddingAdjustment(_ adjustment: Adjustment) -> Bool {

        let mealIngredient = mealIngredientMgr.getByName(name: adjustment.name)


        // Skip Manual / Done / inactive — all three are explicit
        // user signals to leave the row alone:
        //   Manual / Done = user controls the amount; auto stays out.
        //   inactive      = user removed the row from today's meal;
        //                   auto must NOT silently reactivate it,
        //                   otherwise the trash-can swipe ping-pongs.
        if let mi = mealIngredient,
           mi.adjustment == Constants.Manual
           || mi.adjustment == Constants.Done
           || !mi.active {
            return false
        }


        // If the adjustment has constraints, and the new meal
        // ingredient amount with the adjustment applied would exceed
        // the adjustment's maximum constraint for the meal ingredient
        // then the adjustment cannot be applied.
        if mealIngredient != nil && adjustment.constraints {
            if (mealIngredient!.amount + adjustment.amount) > adjustment.maximum {
                return false
            }
        }


        // If the result of applying the adjustment would result in
        // the fat, netCarbs, or protein macros exceeding the daily
        // macro limits then the adjustment cannot be applied.
        //
        // Resolve group/base names to the selected variant (mirrors
        // setMacroActualsAndUpdateMealMacroActuals). If the target
        // ingredient no longer resolves (e.g. an adjustment left over
        // for a removed base entry), the adjustment simply can't be
        // applied — skip it instead of force-unwrapping into a crash.
        guard let ingredient = ingredientMgr.getByName(name: currentName(adjustment.name)) else {
            return false
        }
        let servings = (adjustment.amount * ingredient.consumptionGrams) / ingredient.servingSize

        let fat: Double = Double(ingredient.fat * servings)
        let netCarbs: Double = Double(ingredient.netCarbs * servings)
        let protein: Double = Double(ingredient.protein * servings)

        if macrosMgr.macros.fatGoal < macrosMgr.macros.fat + fat ||
             macrosMgr.macros.netCarbsMaximum < macrosMgr.macros.netCarbs + netCarbs ||
             macrosMgr.macros.proteinGoal < macrosMgr.macros.protein + protein {
            return false
        }


        // At this point, the adjustment "fits" and can be applied.
        setMacroActualsAndUpdateMealMacroActuals(adjustment.name, Double(adjustment.amount), true)
        mealIngredientMgr.automaticAdjustment(name: adjustment.name, amount: adjustment.amount)
        return true
    }


    // For a given meal ingredient (specified by name), use the total
    // calories consumed to determine the servings consumed, and then
    // use the servings consumed to calculate the calories and macros
    // for the meal ingredient, and then set those macro values on the
    // meal ingredient.
    //
    // Next, if the meal ingredient is active, add the meal
    // ingredient's macros to the cumulative meal's macros.
    func setMacroActualsAndUpdateMealMacroActuals(_ name: String, _ amount: Double, _ active: Bool) {

        // Composite row: macros are the sum of each component's
        // selected variant at the component's amount.
        if let mi = mealIngredientMgr.getByName(name: name), mi.isComposite {
            var c = 0.0, f = 0.0, fi = 0.0, nc = 0.0, p = 0.0
            for part in mi.compositeParts {
                guard let ing = ingredientMgr.getByName(name: part.selectedVariantName),
                      ing.servingSize > 0 else { continue }
                let servings = (part.amount * ing.consumptionGrams) / ing.servingSize
                c  += ing.calories * servings
                f  += ing.fat      * servings
                fi += ing.fiber    * servings
                nc += ing.netCarbs * servings
                p  += ing.protein  * servings
            }
            mealIngredientMgr.setMacroActuals(name: name, calories: c, fat: f, fiber: fi, netcarbs: nc, protein: p)
            if active {
                macrosMgr.addMacroActuals(name: name, calories: c, fat: f, fiber: fi, netCarbs: nc, protein: p)
            }
            return
        }

        // Determine the number of servings consumed by taking the
        // total grams consumed divided by the grams per serving.
        // For a GROUP row the meal ingredient is stored under the
        // group name; nutrition must come from the selected member.
        print(name);
        guard let ingredient = ingredientMgr.getByName(name: currentName(name)) else {
            // Group member deleted / unresolved — contribute nothing
            // rather than crashing on a force-unwrap.
            print("  resolution failed for \(name) (lookup \(currentName(name)))")
            return
        }
        let servings = (amount * ingredient.consumptionGrams) / ingredient.servingSize

        // Determine the calories and macros by multiplying the
        // calories/macros per serving times the number of servings
        // consumed.
        let calories: Double = Double(ingredient.calories * servings)
        let fat: Double = Double(ingredient.fat * servings)
        let fiber: Double = Double(ingredient.fiber * servings)
        let netcarbs: Double = Double(ingredient.netCarbs * servings)
        let protein: Double = Double(ingredient.protein * servings)

        // Update the macro values on the meal ingredient
        mealIngredientMgr.setMacroActuals(name: name, calories: calories, fat: fat, fiber: fiber, netcarbs: netcarbs, protein: protein)

        // Add the meal ingredient's macro values to the overall meal actuals
        if active {
            // print("\(name): c: \(calories) f: \(fat) f: \(fiber) n: \(netcarbs) p: \(protein)")
            macrosMgr.addMacroActuals(name: name, calories: calories, fat: fat, fiber: fiber, netCarbs: netcarbs, protein: protein)
        }
    }


    func getBodyWeightAndBodyFatFromHealthKit() {
        HealthStore.authorizeHealthKit { (success, error) in
            guard success else {
                let baseMessage = "HealthKit Authorization Failed"
                if let error = error {
                    print("\(baseMessage). Reason: \(error)")
                } else {
                    print(baseMessage)
                }
                return
            }

            // print("HealthKit successfully authorized.")
            if profileMgr.profile.bodyMassFromHealthKit {
                getBodyMass()
            }
            if profileMgr.profile.bodyFatPercentageFromHealthKit {
                getBodyFatPercentage()
            }
            getActiveEnergyBurned()
        }
    }


    func getBodyMass() {
        // print("Getting body mass")
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            print("Body Mass sample type is no longer available in HealthKit")
            return
        }

        HealthStore.getMostRecentSample(sampleType: sampleType) { (sample, error) in
            guard let sample = sample else {
                if let error = error {
                    print("\(error)")
                }
                return
            }

            let bodyMass = sample.quantity.doubleValue(for: HKUnit.pound())
            print("Weight (healthkit): \(bodyMass)")
            print("Weight (profile): \(profileMgr.profile.bodyMass)")

            if bodyMass != Double(profileMgr.profile.bodyMass) {
                print("Updating body mass...")
                profileMgr.setBodyMass(bodyMass: bodyMass)
            }
        }
    }


    func getBodyFatPercentage() {
        // print("Getting body fat percentage")
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .bodyFatPercentage) else {
            print("Body Fat Percentage sample type is no longer available in HealthKit")
            return
        }

        HealthStore.getMostRecentSample(sampleType: sampleType) { (sample, error) in
            guard let sample = sample else {
                if let error = error {
                    print("\(error)")
                }
                return
            }

            let bodyFatPercentage = (sample.quantity.doubleValue(for: HKUnit.percent())) * 100
            print("Body Fat % (health kit): \(bodyFatPercentage)")
            print("Body Fat % (profile): \(profileMgr.profile.bodyFatPercentage)")

            if bodyFatPercentage != Double(profileMgr.profile.bodyFatPercentage) {
                print("Updating body fat percentage...")
                profileMgr.setBodyFatPercentage(bodyFatPercentage: bodyFatPercentage)
            }
        }
    }


    func getActiveEnergyBurned() {
        // print("Getting active energy burned")
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned) else {
            print("Active Energy Burned sample type is no longer available in HealthKit")
            return
        }

        let calendar = Calendar.current
        var startDateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        startDateComponents.month = startDateComponents.month! - 1
        let startDate = calendar.date(from: startDateComponents)!

        // let energySampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)
        // let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: .None)

        // let query = HKSampleQuery(sampleType: energySampleType!, predicate: predicate, limit: 0, sortDescriptors: nil) { (query, results, error) in
        HealthStore.getMostRecentSample(sampleType: sampleType, startDate: startDate) { (sample, error) in
            guard let sample = sample else {
                if let error = error {
                    print("\(error)")
                }
                return
            }

            let activeCaloriesBurned = sample.quantity.doubleValue(for: HKUnit.kilocalorie())
            print("Active energy burned (health kit): \(activeCaloriesBurned)")
            print("Active energy burned (profile): \(profileMgr.profile.activeCaloriesBurned)")

            // TODO: Update once the health kit active calories algorithm is demystified
            // if activeCaloriesBurned != profileMgr.profile.activeCaloriesBurned {
            //     print("Updating active energy burned...")
            //     profileMgr.setActiveEnergyBurned(activeCaloriesBurned: activeCaloriesBurned)
            // }
        }
    }


    func getConsumptionUnit(_ name: String) -> Unit {
        // `name` may be a group name (meal row stored under the
        // group); resolve to the selected member, and never crash if
        // it can't be found.
        return ingredientMgr.getByName(name: currentName(name))?.consumptionUnit ?? .gram
    }


    // A meal row's `name` is a Food name. The ingredient it resolves
    // to is that Food's CURRENT ingredient (global, single source of
    // truth). Fallbacks keep it crash-proof if data is inconsistent.
    func currentName(_ foodOrName: String) -> String {
        if let f = foodMgr.getByName(name: foodOrName),
           ingredientMgr.getByName(name: f.currentIngredientName) != nil {
            return f.currentIngredientName
        }
        return foodOrName
    }

    func resolvedIngredient(_ mi: MealIngredient) -> Ingredient? {
        if let ing = ingredientMgr.getByName(name: currentName(mi.name)) {
            return ing
        }
        // Last-ditch: any surviving member of the Food.
        return ingredientMgr.getAll().first { $0.foodName == mi.name }
    }


    // Name + brand subtext, mirroring the prep screen exactly:
    // .callout name (inherits the row's mode color, applied by the
    // caller) + .caption2 brand in the secondary color.
    @ViewBuilder
    func mealNameLabel(_ mi: MealIngredient) -> some View {
        let brand = resolvedIngredient(mi)?.brand ?? ""
        VStack(alignment: .leading, spacing: 1) {
            Text(mi.name)
              .font(.callout)
            if !brand.isEmpty {
                Text(brand)
                  .font(.caption2)
                  .foregroundColor(Color.theme.blackWhiteSecondary)
            }
        }
    }

    // Members of the group a meal row represents (for the picker).
    func groupMembers(_ mi: MealIngredient) -> [Ingredient] {
        ingredientMgr.getAll().filter { $0.foodName == mi.name }
    }


    func isGroupRow(_ mi: MealIngredient) -> Bool {
        foodMgr.getByName(name: mi.name) != nil
    }


    func selectGroupMember(_ mi: MealIngredient, member: String) {
        // Selection is global per Food — set the Food's current
        // ingredient; every screen resolves through it.
        foodMgr.setCurrent(food: mi.name, member: member)
        // Adopt the picked variant's preset amount (e.g. Avocado
        // Large 225 g vs Medium 140 g). Skip when it has no preset
        // so a user's hand-set amount is preserved.
        if let amt = ingredientMgr.getByName(name: member)?.defaultAmount, amt > 0 {
            mealIngredientMgr.setAmount(name: mi.name, amount: amt)
        }
        generateMeal()
    }


    // Resolve a Food to the variant a composite should start with:
    // its current default member, else any member, else the Food
    // name itself (defensive).
    private func defaultVariant(forFood foodName: String) -> String {
        foodMgr.getByName(name: foodName)?.currentIngredientName
            ?? ingredientMgr.getAll().first { $0.foodName == foodName }?.name
            ?? foodName
    }


    // Add (or toggle off) a composite in the meal. Snapshots each
    // component to its Food's current default variant. Created as
    // Manual so the auto-adjust engine leaves it alone.
    func addComposite(_ composite: FoodComposite) {
        if let existing = mealIngredientMgr.getByName(name: composite.name) {
            mealIngredientMgr.delete(existing)
            generateMeal()
            return
        }
        let parts = composite.components.map { c in
            MealCompositePart(foodName: c.foodName,
                              selectedVariantName: defaultVariant(forFood: c.foodName),
                              amount: c.amount)
        }
        mealIngredientMgr.create(name: composite.name,
                                 amount: 0,
                                 adjustment: Constants.Manual,
                                 active: true,
                                 compositeParts: parts)
        generateMeal()
    }
}

//struct MealIngredientList_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            MealIngredientList()
//              .environmentObject(MealIngredientMgr())
//        }
//    }
//}


// =============================================================
// ProteinsEditor — inlined here (not its own file) so it's part
// of the existing MealList compilation unit and doesn't require
// touching project.pbxproj.
// =============================================================
//
// Sheet for editing the proteins that get auto-added to every meal.
// Each row is one Protein: a meat-type Picker + a grams TextField +
// a trash button (hidden on the last remaining row — you zero the
// grams instead of removing it).
//
// Source of truth while editing: `draft`, a local copy of
// profileMgr.profile.proteins. Save commits draft via
// ProfileMgr.setProteins(...); Cancel discards.
struct ProteinsEditor: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var profileMgr: ProfileMgr
    @EnvironmentObject var foodMgr: FoodMgr

    @State private var draft: [Protein] = []
    // Mirror of each row's amount as a string so the user can clear
    // the field while typing without flipping back to 0. Keyed by
    // Protein.id. Synced from draft on appear and on row changes.
    @State private var amountStrings: [UUID: String] = [:]


    var body: some View {
        NavigationView {
            Form {
                Section {
                    ForEach(draft) { protein in
                        rowFor(protein)
                    }
                }

                Section {
                    Button {
                        addProtein()
                    } label: {
                        Label("Add protein", systemImage: "plus.circle")
                          .foregroundColor(Color.theme.blueYellow)
                    }
                }
            }
              .navigationTitle("Proteins")
              .navigationBarTitleDisplayMode(.inline)
              .toolbar {
                  ToolbarItem(placement: .navigation) {
                      Button("Cancel") {
                          presentationMode.wrappedValue.dismiss()
                      }
                        .foregroundColor(Color.theme.blueYellow)
                  }
                  ToolbarItem(placement: .primaryAction) {
                      Button("Save") {
                          commitAndDismiss()
                      }
                        .foregroundColor(Color.theme.blueYellow)
                  }
              }
              .onAppear {
                  draft = profileMgr.profile.proteins
                  // Profile invariant says proteins is non-empty, but
                  // be defensive — an empty list would render an empty
                  // sheet with no way to add anything (the Add button
                  // exists but feels wrong).
                  if draft.isEmpty {
                      draft = [defaultNewProtein()]
                  }
                  amountStrings = Dictionary(uniqueKeysWithValues:
                      draft.map { ($0.id, formatAmount($0.amount)) })
              }
        }
    }


    // One row of the editor: [Meat picker] [amount text] grams (trash)
    @ViewBuilder
    private func rowFor(_ protein: Protein) -> some View {
        let idx = draft.firstIndex(where: { $0.id == protein.id }) ?? 0
        HStack(spacing: 8) {
            Picker("", selection: Binding(
                get: { draft[idx].name },
                set: { newName in
                    draft[idx].name = newName
                    // Per the design: switching meat type auto-resets
                    // the amount to that ingredient's default
                    // meatAmount so the user gets the "right" weight
                    // for the protein they just picked.
                    let defaultAmt = ingredientMgr.getByName(name: newName)?.meatAmount ?? draft[idx].amount
                    draft[idx].amount = defaultAmt
                    amountStrings[protein.id] = formatAmount(defaultAmt)
                }
            )) {
                ForEach(availableMeatNames(), id: \.self) { name in
                    Text(name).tag(name)
                }
            }
              .pickerStyle(.menu)
              .labelsHidden()
              .tint(Color.theme.blueYellow)

            // Pushes the amount + unit + trash to the right edge so
            // they stay column-aligned across rows regardless of how
            // long the meat name is ("Pork Chop" vs "Beef").
            Spacer()

            TextField("amount", text: Binding(
                get: { amountStrings[protein.id] ?? formatAmount(draft[idx].amount) },
                set: { newText in
                    amountStrings[protein.id] = newText
                    if let value = Double(newText) {
                        draft[idx].amount = value
                    }
                }
            ))
              .keyboardType(.decimalPad)
              .multilineTextAlignment(.trailing)
              .frame(maxWidth: 90)

            Text("grams")
              .font(.caption)
              .foregroundColor(Color.theme.blackWhiteSecondary)

            // Trash hidden on the last remaining row — the design
            // requires at least one protein at all times. Zero-amount
            // is allowed as a "soft removal" that still leaves the
            // row editable.
            if draft.count > 1 {
                Button(role: .destructive) {
                    removeProtein(id: protein.id)
                } label: {
                    Image(systemName: "trash")
                      .foregroundColor(Color.theme.red)
                }
                  .buttonStyle(.borderless)
            }
        }
    }


    // All meat ingredients (minus the sentinel "None") in their
    // original definition order. Same source as the legacy Meat
    // picker in MealConfigure used.
    private func availableMeatNames() -> [String] {
        ingredientMgr.getAllMeatNames(foodMgr: foodMgr).filter { $0 != "None" }
    }


    // Pick a sensible new-row default: first meat not already in the
    // draft (so adding three times yields three different proteins
    // when possible); fall back to the first available name if every
    // protein is already taken.
    private func defaultNewProtein() -> Protein {
        let used = Set(draft.map { $0.name })
        let names = availableMeatNames()
        let pick = names.first(where: { !used.contains($0) }) ?? names.first ?? "Chicken (Mary's Chicken)"
        let amt = ingredientMgr.getByName(name: pick)?.meatAmount ?? 100
        return Protein(name: pick, amount: amt)
    }


    private func addProtein() {
        let p = defaultNewProtein()
        draft.append(p)
        amountStrings[p.id] = formatAmount(p.amount)
    }


    private func removeProtein(id: UUID) {
        draft.removeAll(where: { $0.id == id })
        amountStrings[id] = nil
    }


    private func commitAndDismiss() {
        // Defensive: ensure every row's typed amount made it into the
        // draft (user might tap Save while the field is mid-edit and
        // hasn't fired its setter yet).
        for (i, p) in draft.enumerated() {
            if let s = amountStrings[p.id], let v = Double(s) {
                draft[i].amount = v
            }
        }
        profileMgr.setProteins(draft)
        presentationMode.wrappedValue.dismiss()
    }


    // Mirror NumberEntrySheet's formatter: drop the decimal point
    // when the value is a whole number (so "200" appears in the
    // field, not "200.0").
    private func formatAmount(_ value: Double) -> String {
        if value == value.rounded() {
            return String(Int(value))
        }
        return String(value)
    }
}


// ============================================================
// CompositeEditor — the dedicated screen a composite meal row
// opens on long-press. Per component: swap the Food's variant
// and adjust the amount. Changes apply live (onChange fires the
// meal regeneration); Done dismisses.
// ============================================================
struct CompositeEditor: View {

    @Environment(\.presentationMode) private var presentationMode

    let compositeName: String
    let variants: (String) -> [String]
    let onChange: ([MealCompositePart]) -> Void

    @State private var parts: [MealCompositePart]

    init(compositeName: String,
         parts: [MealCompositePart],
         variants: @escaping (String) -> [String],
         onChange: @escaping ([MealCompositePart]) -> Void) {
        self.compositeName = compositeName
        self.variants = variants
        self.onChange = onChange
        _parts = State(initialValue: parts)
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(parts.indices, id: \.self) { i in
                    Section(header: Text(parts[i].foodName)) {

                        Picker("Variant", selection: Binding(
                            get: { parts[i].selectedVariantName },
                            set: { parts[i].selectedVariantName = $0; onChange(parts) }
                        )) {
                            ForEach(variants(parts[i].foodName), id: \.self) { v in
                                Text(v).tag(v)
                            }
                        }

                        HStack {
                            Text("Amount")
                            Spacer()
                            Button {
                                parts[i].amount = max(0, parts[i].amount - 1)
                                onChange(parts)
                            } label: {
                                Image(systemName: "minus.circle")
                            }
                              .buttonStyle(.borderless)
                            Text(amountText(parts[i].amount))
                              .frame(minWidth: 44)
                              .multilineTextAlignment(.center)
                            Button {
                                parts[i].amount += 1
                                onChange(parts)
                            } label: {
                                Image(systemName: "plus.circle")
                            }
                              .buttonStyle(.borderless)
                        }
                          .foregroundColor(Color.theme.blueYellow)
                    }
                }
            }
              .navigationTitle(compositeName)
              .navigationBarTitleDisplayMode(.inline)
              .toolbar {
                  ToolbarItem(placement: .confirmationAction) {
                      Button("Done") {
                          presentationMode.wrappedValue.dismiss()
                      }
                        .foregroundColor(Color.theme.blueYellow)
                  }
              }
        }
    }

    private func amountText(_ v: Double) -> String {
        v == v.rounded() ? String(Int(v)) : String(format: "%.1f", v)
    }
}
