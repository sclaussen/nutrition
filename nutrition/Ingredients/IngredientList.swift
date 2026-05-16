import SwiftUI

struct IngredientList: View {

    @EnvironmentObject var ingredientMgr: IngredientMgr
    @EnvironmentObject var mealIngredientMgr: MealIngredientMgr
    @EnvironmentObject var adjustmentMgr: AdjustmentMgr
    @EnvironmentObject var foodMgr: FoodMgr
    @EnvironmentObject var foodCompositeMgr: FoodCompositeMgr

    @State var deleteMealIngredientAlert = false
    @State var deleteAdjustmentAlert = false

    // Non-nil drives the hidden background NavigationLink that pushes
    // IngredientEdit. Set by tapping the chevron on a row; cleared
    // when the editor screen is dismissed.
    @State private var editIngredient: Ingredient? = nil

    // Prep list granularity.
    //   .composite  — list FoodComposites (PB&J, Wrap, …) + create
    //   .food       — collapsed Food rows (default)
    //   .ingredient — every individual Ingredient incl. all variants
    enum PrepMode { case composite, food, ingredient }
    @State private var prepMode: PrepMode = .food

    // Non-nil while the new-composite builder sheet is shown.
    @State private var showCompositeBuilder = false

    // ============================================================
    // Scanner state. The toolbar camera button presents
    // LabelCaptureSheet; on completion it hands back a ScanRoute
    // that we stash into one of these state vars to drive the
    // appropriate navigation:
    //   * .new(parsed)         -> showAddPrefilled = parsed
    //   * .update(...)         -> showEditPrefilled = (existing,parsed,diff)
    //   * .chooser(...)        -> chooserPayload = (parsed,candidates)
    // We keep them as separate optionals so each navigation /
    // sheet binding stays simple and self-contained.
    // ============================================================
    @State private var showCaptureSheet = false

    @State private var addPrefill: ParsedIngredient? = nil
    @State private var editPrefillBundle: EditPrefillBundle? = nil
    @State private var chooserPayload: ChooserPayload? = nil

    // Pull the navigation flag off Identifiable Optionals so the
    // hidden NavigationLink Bindings stay readable.
    private var addPrefillActive: Binding<Bool> {
        Binding(get: { addPrefill != nil },
                set: { if !$0 { addPrefill = nil } })
    }
    private var editPrefillActive: Binding<Bool> {
        Binding(get: { editPrefillBundle != nil },
                set: { if !$0 { editPrefillBundle = nil } })
    }


    // Wrappers so we can drive a navigation Binding<Bool> without
    // losing the payload. (Tuples aren't Identifiable, structs are.)
    struct EditPrefillBundle {
        let existing: Ingredient
        let parsed: ParsedIngredient
        let diff: ScanDiff
    }
    struct ChooserPayload: Identifiable {
        let parsed: ParsedIngredient
        let candidates: [Ingredient]
        var id: String { parsed.name }
    }

    var body: some View {
        List {

            IngredientRowHeader(showMacros: false, showAmount: false)
              .listRowInsets(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))

            Picker("View", selection: $prepMode) {
                Text("Composite").tag(PrepMode.composite)
                Text("Food").tag(PrepMode.food)
                Text("Ingredient").tag(PrepMode.ingredient)
            }
              .pickerStyle(.segmented)
              .listRowInsets(EdgeInsets(top: 4, leading: 10, bottom: 8, trailing: 10))

            if prepMode == .composite {
                compositeSection
            } else {
            ForEach(getIngredientList()) { ingredient in
                // Row is split between two hit zones, each wrapped in
                // a Button with .buttonStyle(.borderless) so the List
                // row doesn't lump them into a single tappable unit:
                //   * Name Button — taps toggle the ingredient in/out
                //     of the meal (black <-> green).
                //   * trailing chevron Button — pushes IngredientEdit
                //     via the hidden NavigationLink in .background.
                // Explicit .frame(height: 28) on the HStack keeps the
                // row from collapsing — IngredientRow's inner
                // GeometryReader has no intrinsic height, so without
                // this the row would shrink to chevron-sized.
                HStack(spacing: 0) {
                    Button {
                        promote(ingredient)
                    } label: {
                        // Plain Text uses the full row width instead of
                        // IngredientRow's 39.5% name slot (designed
                        // around macro columns we no longer show).
                        HStack(spacing: 4) {
                            Text(displayName(ingredient))
                              .font(.callout)
                              .foregroundColor(statusColor(for: ingredient))
                            if AvoidList.firstMatch(in: ingredient.ingredients) != nil {
                                Image(systemName: "exclamationmark.triangle.fill")
                                  .font(.caption2)
                                  .foregroundColor(.orange)
                            }
                        }
                          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                          .contentShape(Rectangle())
                    }
                      .buttonStyle(.borderless)

                    Button {
                        editIngredient = ingredient
                    } label: {
                        Image(systemName: "chevron.right")
                          .font(.caption2)
                          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                          .contentShape(Rectangle())
                    }
                      .buttonStyle(.borderless)
                      .foregroundColor(Color.theme.blackWhiteSecondary)
                      .frame(width: 30)
                }
                  .frame(height: 28)

                  .swipeActions(edge: .trailing) {
                      // Delete from the database entirely.
                      Button(role: .destructive) {
                          delete(ingredient)
                      } label: {
                          Label("Delete", systemImage: "trash.fill")
                      }

                      // Remove from the meal list (back to black /
                      // not-in-meal) without deleting from the
                      // database. Only shown when the ingredient is
                      // actually in the meal. Redundant with the tap-
                      // toggle, but kept as a discoverable affordance.
                      if isInMeal(ingredient) {
                          Button {
                              removeFromMeal(ingredient)
                          } label: {
                              Label("Unlist", systemImage: "minus.circle")
                          }
                            .tint(.red)
                      }
                  }
            }
              .listRowInsets(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
              .border(Color.theme.red, width: 0)
            }
        }
          .alert("The meal ingredient must be deleted first.  It may be necessary to lock the meal ingredients prior to deletion so the meal ingredient is not readded as an adjustment.", isPresented: $deleteMealIngredientAlert) {
              Button("OK", role: .cancel) { }
          }
          .alert("The adjustment ingredient must be deleted first.", isPresented: $deleteAdjustmentAlert) {
              Button("OK", role: .cancel) { }
          }
          .environment(\.defaultMinListRowHeight, 5)
          .padding([.leading, .trailing], -20)
          .toolbar {
              ToolbarItem(placement: .principal) {
                  // Centered cluster: adjustments link + the LLM
                  // scanner. The scanner glyph is rendered 50% larger
                  // than the others (it's the primary action on this
                  // screen). Scanner Settings moved to Profile.
                  HStack(spacing: 22) {
                      NavigationLink(destination: AdjustmentList()) {
                          Image(systemName: "slider.horizontal.below.list.bulleted")
                      }

                      Button {
                          showCaptureSheet = true
                      } label: {
                          Image(systemName: "camera.viewfinder")
                            .font(.system(size: 27))
                      }
                  }
                    .foregroundColor(Color.theme.blueYellow)
              }
              ToolbarItem(placement: .primaryAction) {
                  NavigationLink("Add", destination: IngredientAdd())
                    .foregroundColor(Color.theme.blueYellow)
              }
          }
          // Scanner sheets — capture, then optional chooser, then
          // routed navigation into Add or Edit prefilled.
          .sheet(isPresented: $showCaptureSheet) {
              LabelCaptureSheet { route in
                  applyScanRoute(route)
              }
                .environmentObject(ingredientMgr)
          }
          .sheet(item: $chooserPayload) { payload in
              MatchChooserSheet(parsed: payload.parsed,
                                candidates: payload.candidates) { resolved in
                  applyScanRoute(resolved)
              }
          }
          .sheet(isPresented: $showCompositeBuilder) {
              CompositeBuilder(foods: foodMgr.names) { name, components in
                  foodCompositeMgr.create(name: name, components: components)
              }
          }
          // Hidden NavigationLinks that fire when scan results route
          // to Add (with prefill) or Edit (with prefill + diff).
          .background(
              Group {
                  NavigationLink(
                      destination: Group {
                          if let p = addPrefill { IngredientAdd(prefill: p) }
                      },
                      isActive: addPrefillActive
                  ) { EmptyView() }

                  NavigationLink(
                      destination: Group {
                          if let b = editPrefillBundle {
                              IngredientEdit(ingredient: b.existing,
                                             prefill: b.parsed,
                                             diff: b.diff)
                          }
                      },
                      isActive: editPrefillActive
                  ) { EmptyView() }
              }
          )
          // Hidden NavigationLink driven by `editIngredient`. Pattern
          // mirrors MealList's detail navigation — gives us a
          // chevron Button (visible) that pushes IngredientEdit
          // (invisible link) without making the whole list row a
          // single big NavigationLink.
          .background(
              NavigationLink(
                  destination: Group {
                      if let ing = editIngredient {
                          IngredientEdit(ingredient: ing)
                      }
                  },
                  isActive: Binding(
                      get: { editIngredient != nil },
                      set: { if !$0 { editIngredient = nil } }
                  )
              ) {
                  EmptyView()
              }
          )
    }

    // Collapse grouped ingredients to one row per group. The
    // representative is the group's default member (real Ingredient,
    // so the chevron still edits real data); the row DISPLAYS the
    // group name and toggles the group into the meal under that name.
    // Composite mode: list FoodComposites (tap toggles into the
    // meal, like an ingredient row) plus a create entry.
    @ViewBuilder
    private var compositeSection: some View {
        ForEach(foodCompositeMgr.composites) { comp in
            HStack(spacing: 8) {
                Text(comp.name)
                  .font(.callout)
                  .foregroundColor(compositeInMeal(comp) ? Color.theme.manual
                                                         : Color.theme.blackWhite)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .contentShape(Rectangle())
                  .onTapGesture { toggleComposite(comp) }
                Text(comp.components.map { $0.foodName }.joined(separator: " + "))
                  .font(.caption2)
                  .foregroundColor(Color.theme.blackWhiteSecondary)
                  .lineLimit(1)
            }
              .listRowInsets(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
        }
        Button {
            showCompositeBuilder = true
        } label: {
            Label("New composite", systemImage: "plus.circle")
              .foregroundColor(Color.theme.blueYellow)
        }
          .listRowInsets(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
    }

    private func compositeInMeal(_ c: FoodComposite) -> Bool {
        mealIngredientMgr.getByName(name: c.name) != nil
    }

    private func defaultVariant(forFood food: String) -> String {
        foodMgr.getByName(name: food)?.defaultMemberName
            ?? ingredientMgr.getAll().first { $0.foodName == food }?.name
            ?? food
    }

    private func toggleComposite(_ c: FoodComposite) {
        if let mi = mealIngredientMgr.getByName(name: c.name) {
            mealIngredientMgr.delete(mi)
            return
        }
        let parts = c.components.map { comp in
            MealCompositePart(foodName: comp.foodName,
                              selectedVariantName: defaultVariant(forFood: comp.foodName),
                              amount: comp.amount)
        }
        mealIngredientMgr.create(name: c.name, amount: 0,
                                 adjustment: Constants.Manual, active: true,
                                 compositeParts: parts)
    }


    func getIngredientList() -> [Ingredient] {
        let all = ingredientMgr.getAll()
        if prepMode == .ingredient {
            // Expanded: every Ingredient, including each Food's
            // variants, shown under its own name.
            return all.sorted { displayName($0) < displayName($1) }
        }
        var result: [Ingredient] = []
        var seenGroups = Set<String>()
        for ing in all {
            if ing.foodName.isEmpty {
                result.append(ing)
                continue
            }
            if seenGroups.contains(ing.foodName) { continue }
            seenGroups.insert(ing.foodName)
            if let g = foodMgr.getByName(name: ing.foodName),
               let def = ingredientMgr.getByName(name: g.defaultMemberName) {
                result.append(def)
            } else {
                result.append(ing)
            }
        }
        return result.sorted { displayName($0) < displayName($1) }
    }


    // What the row shows: group name for grouped ingredients,
    // otherwise the ingredient's own name.
    private func displayName(_ ing: Ingredient) -> String {
        if prepMode == .ingredient { return ing.name }
        return ing.foodName.isEmpty ? ing.name : ing.foodName
    }

    // The meal-list key: a grouped ingredient is tracked in the meal
    // under its GROUP name (MealIngredient.name == group name).
    private func mealKey(_ ing: Ingredient) -> String {
        ing.foodName.isEmpty ? ing.name : ing.foodName
    }


    // ============================================================
    // ScanRoute dispatcher — set the appropriate state var so the
    // matching hidden NavigationLink fires (or the chooser sheet
    // presents). Called either after the capture sheet completes,
    // or after the user picks a candidate in the chooser.
    // ============================================================
    private func applyScanRoute(_ route: ScanRoute) {
        switch route {
        case .new(let parsed):
            addPrefill = parsed
        case .update(let existing, let parsed, let diff):
            editPrefillBundle = EditPrefillBundle(
                existing: existing, parsed: parsed, diff: diff
            )
        case .chooser(let parsed, let candidates):
            chooserPayload = ChooserPayload(parsed: parsed, candidates: candidates)
        }
    }

    // Two states on the prep page — the ingredient is either in the
    // current meal or it isn't. Active/inactive is the meal page's
    // concern, not this one.
    private func isInMeal(_ ingredient: Ingredient) -> Bool {
        mealIngredientMgr.getByName(name: mealKey(ingredient)) != nil
    }


    // Color encoding:
    //   blue                 = meat (managed via Proteins picker, not here)
    //   black (primary text) = not in the meal
    //   green                = in the meal
    private func statusColor(for ingredient: Ingredient) -> Color {
        if ingredient.meat { return Color.theme.blue }
        return isInMeal(ingredient) ? Color.theme.manual : Color.theme.blackWhite
    }


    // Toggle the ingredient in/out of the meal:
    //   black -> green  (added to meal, active: true)
    //   green -> black  (removed from meal)
    //
    // No-op for meats: they're owned by the Proteins picker. The
    // chevron still navigates to IngredientEdit so the meat's data
    // is reachable.
    private func promote(_ ingredient: Ingredient) {
        if ingredient.meat { return }
        let key = mealKey(ingredient)
        if let mi = mealIngredientMgr.getByName(name: key) {
            mealIngredientMgr.delete(mi)
        } else if ingredient.foodName.isEmpty {
            mealIngredientMgr.create(name: ingredient.name,
                                     amount: ingredient.defaultAmount,
                                     active: true,
                                     isSupplement: ingredient.supplement)
        } else {
            // Grouped: the meal row is the Food; seed it with the
            // Food's default variant so macros/cost resolve, and use
            // that variant's defaultAmount as the starting amount.
            let member = foodMgr.getByName(name: ingredient.foodName)?.defaultMemberName
                ?? ingredient.name
            let amount = ingredientMgr.getByName(name: member)?.defaultAmount ?? 0
            mealIngredientMgr.create(name: ingredient.foodName,
                                     amount: amount,
                                     active: true,
                                     isSupplement: ingredient.supplement,
                                     selectedMemberName: member)
        }
    }


    private func removeFromMeal(_ ingredient: Ingredient) {
        if let mi = mealIngredientMgr.getByName(name: mealKey(ingredient)) {
            mealIngredientMgr.delete(mi)
        }
    }


    func delete(_ ingredient: Ingredient) {
        if let mealIngredient = mealIngredientMgr.getByName(name: ingredient.name) {
            deleteMealIngredientAlert = true
            return
        }
        if let adjustment = adjustmentMgr.getByName(name: ingredient.name) {
            deleteAdjustmentAlert = true
            return
        }
        ingredientMgr.delete(ingredient)
    }
}

struct IngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IngredientList()
              .environmentObject(IngredientMgr())
        }
    }
}


// ============================================================
// CompositeBuilder — create a new FoodComposite from existing
// Foods. Pick components, set each amount, name it, Save.
// ============================================================
struct CompositeBuilder: View {

    @Environment(\.presentationMode) private var presentationMode

    let foods: [String]
    let onSave: (String, [CompositeComponent]) -> Void

    @State private var name = ""
    @State private var included: Set<String> = []
    @State private var amounts: [String: Double] = [:]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Composite name", text: $name)
                      .autocorrectionDisabled()
                }
                Section(header: Text("Components")) {
                    ForEach(foods, id: \.self) { f in
                        HStack {
                            Button {
                                if included.contains(f) {
                                    included.remove(f)
                                } else {
                                    included.insert(f)
                                    if amounts[f] == nil { amounts[f] = 1 }
                                }
                            } label: {
                                Image(systemName: included.contains(f)
                                      ? "checkmark.circle.fill" : "circle")
                            }
                              .buttonStyle(.borderless)
                              .foregroundColor(Color.theme.blueYellow)
                            Text(f)
                            Spacer()
                            if included.contains(f) {
                                Stepper(value: Binding(
                                    get: { amounts[f] ?? 1 },
                                    set: { amounts[f] = max(0, $0) }
                                ), in: 0...100, step: 1) {
                                    Text(amountText(amounts[f] ?? 1))
                                      .frame(minWidth: 28)
                                }
                                  .labelsHidden()
                                  .fixedSize()
                            }
                        }
                    }
                }
            }
              .navigationTitle("New composite")
              .navigationBarTitleDisplayMode(.inline)
              .toolbar {
                  ToolbarItem(placement: .cancellationAction) {
                      Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                        .foregroundColor(Color.theme.blueYellow)
                  }
                  ToolbarItem(placement: .confirmationAction) {
                      Button("Save") {
                          let comps = foods
                            .filter { included.contains($0) }
                            .map { CompositeComponent(foodName: $0,
                                                      amount: amounts[$0] ?? 1) }
                          let trimmed = name.trimmingCharacters(in: .whitespaces)
                          if !trimmed.isEmpty && !comps.isEmpty {
                              onSave(trimmed, comps)
                          }
                          presentationMode.wrappedValue.dismiss()
                      }
                        .foregroundColor(Color.theme.blueYellow)
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty
                                  || included.isEmpty)
                  }
              }
        }
    }

    private func amountText(_ v: Double) -> String {
        v == v.rounded() ? String(Int(v)) : String(format: "%.1f", v)
    }
}
