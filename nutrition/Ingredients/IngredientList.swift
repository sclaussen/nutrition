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

    // Sort applied to all three tabs. Name is alphabetical; the
    // others are per-100g (cost = price per 100g), highest first.
    enum SortBy: String, CaseIterable, Identifiable {
        case name = "Name"
        case protein = "Protein"
        case carbs = "Carbs"
        case fat = "Fat"
        case cost = "Cost/100g"
        var id: String { rawValue }
    }
    @State private var sortBy: SortBy = .name

    // Non-nil while the new-composite builder sheet is shown.
    @State private var showCompositeBuilder = false

    // Non-nil while editing an existing composite (chevron tapped).
    @State private var editComposite: FoodComposite? = nil

    // Drives the hidden NavigationLink that pushes IngredientAdd when
    // the toolbar "Add" is tapped in Food / Ingredient mode.
    @State private var showAdd = false

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

    // Drives the hidden NavigationLink that pushes the all-items
    // "Verify All" web-refresh sweep.
    @State private var showVerifyAll = false

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
        VStack(spacing: 0) {

            // Pinned header: stays put while the List below scrolls.
            Picker("View", selection: $prepMode) {
                Text("Composite").tag(PrepMode.composite)
                Text("Food").tag(PrepMode.food)
                Text("Ingredient").tag(PrepMode.ingredient)
            }
              .pickerStyle(.segmented)
              .padding(EdgeInsets(top: 4, leading: 16, bottom: 8, trailing: 16))

            List {

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
                        toggleFoodActive(ingredient)
                    } label: {
                        // Name + tiny brand subtext. Tapping toggles
                        // whether this ingredient is an active member
                        // of its Food (green) vs inactive (black).
                        VStack(alignment: .leading, spacing: 1) {
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
                            if !ingredient.brand.isEmpty {
                                Text(ingredient.brand)
                                  .font(.caption2)
                                  .foregroundColor(Color.theme.blackWhiteSecondary)
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
              .listStyle(.plain)
              .environment(\.defaultMinListRowHeight, 5)
              // Composite mode is a short list (a handful of recipes);
              // cap it at the top ~20% of the screen rather than
              // letting it stretch full-height.
              .frame(maxHeight: prepMode == .composite
                                  ? UIScreen.main.bounds.height * 0.20
                                  : .infinity)
            if prepMode == .composite { Spacer() }
        }
          .alert("The meal ingredient must be deleted first.  It may be necessary to lock the meal ingredients prior to deletion so the meal ingredient is not readded as an adjustment.", isPresented: $deleteMealIngredientAlert) {
              Button("OK", role: .cancel) { }
          }
          .alert("The adjustment ingredient must be deleted first.", isPresented: $deleteAdjustmentAlert) {
              Button("OK", role: .cancel) { }
          }
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

                      Menu {
                          Picker("Sort", selection: $sortBy) {
                              ForEach(SortBy.allCases) { s in
                                  Text(s.rawValue).tag(s)
                              }
                          }
                      } label: {
                          Image(systemName: "arrow.up.arrow.down")
                      }

                      Button {
                          showCaptureSheet = true
                      } label: {
                          Image(systemName: "camera.viewfinder")
                            .font(.system(size: 24.3))
                      }

                      // All-items web-refresh sweep (Verify All).
                      Button {
                          showVerifyAll = true
                      } label: {
                          Image(systemName: "checkmark.seal")
                      }
                  }
                    .foregroundColor(Color.theme.blueYellow)
              }
              ToolbarItem(placement: .primaryAction) {
                  // Add is contextual to the selected segment:
                  //   Composite -> new-composite builder (same as the
                  //                "New composite" row)
                  //   Food / Ingredient -> IngredientAdd
                  Button("Add") {
                      if prepMode == .composite {
                          showCompositeBuilder = true
                      } else {
                          showAdd = true
                      }
                  }
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
              CompositeBuilder(foods: foodMgr.namesSorted) { name, components in
                  foodCompositeMgr.create(name: name, components: components)
              }
          }
          .sheet(item: $editComposite) { comp in
              CompositeBuilder(existing: comp, foods: foodMgr.namesSorted) { name, components in
                  foodCompositeMgr.update(
                      FoodComposite(id: comp.id, name: name, components: components))
              } onDelete: {
                  foodCompositeMgr.remove(name: comp.name)
              }
          }
          // Hidden NavigationLinks that fire when scan results route
          // to Add (with prefill) or Edit (with prefill + diff).
          .background(
              Group {
                  NavigationLink(
                      destination: IngredientAdd(),
                      isActive: $showAdd
                  ) { EmptyView() }

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

                  NavigationLink(
                      destination: VerifyAllWalkthrough()
                        .environmentObject(ingredientMgr),
                      isActive: $showVerifyAll
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
        ForEach(sortedComposites()) { comp in
            HStack(spacing: 8) {
                Text(comp.name)
                  .font(.callout)
                  .foregroundColor(compositeInMeal(comp) ? Color.theme.manual
                                                         : Color.theme.blackWhite)
                  .contentShape(Rectangle())
                  .onTapGesture { toggleComposite(comp) }
                Text(comp.components.map { $0.foodName }.joined(separator: " + "))
                  .font(.caption2)
                  .foregroundColor(Color.theme.blackWhiteSecondary)
                  .lineLimit(1)
                  .frame(maxWidth: .infinity, alignment: .trailing)
                // Chevron → edit, mirroring the ingredient rows.
                Button {
                    editComposite = comp
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
              .listRowInsets(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
        }
    }

    private func compositeInMeal(_ c: FoodComposite) -> Bool {
        mealIngredientMgr.getByName(name: c.name) != nil
    }

    private func defaultVariant(forFood food: String) -> String {
        foodMgr.getByName(name: food)?.currentIngredientName
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
            return applySort(all)
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
               let def = ingredientMgr.getByName(name: g.currentIngredientName) {
                result.append(def)
            } else {
                result.append(ing)
            }
        }
        return applySort(result)
    }


    private func costPer100(_ ing: Ingredient) -> Double {
        ing.totalGrams > 0 ? (ing.totalCost / ing.totalGrams) * 100 : 0
    }

    // The ingredient's category rank, resolved through its Food.
    // Foodless ingredients sort last (Int.max).
    private func typeRank(_ ing: Ingredient) -> Int {
        foodMgr.type(of: ing)?.sortRank ?? Int.max
    }

    // Shared sort for the Food and Ingredient tabs. Name groups by
    // the Food's category (sortRank) then name; protein / carbs /
    // fat / cost are per-100g, highest first.
    private func applySort(_ items: [Ingredient]) -> [Ingredient] {
        switch sortBy {
        case .name:
            return items.sorted {
                typeRank($0) != typeRank($1)
                  ? typeRank($0) < typeRank($1)
                  : displayName($0) < displayName($1)
            }
        case .protein: return items.sorted { $0.protein100  > $1.protein100 }
        case .carbs:   return items.sorted { $0.netCarbs100  > $1.netCarbs100 }
        case .fat:     return items.sorted { $0.fat100       > $1.fat100 }
        case .cost:    return items.sorted { costPer100($0)  > costPer100($1) }
        }
    }

    // Composite tab uses the same selector. The metric is the sum of
    // each component's default variant's per-100g value (or per-100g
    // cost); Name is alphabetical.
    private func compositeMetric(_ c: FoodComposite) -> Double {
        var total = 0.0
        for comp in c.components {
            guard let ing = ingredientMgr.getByName(
                name: defaultVariant(forFood: comp.foodName)) else { continue }
            switch sortBy {
            case .protein: total += ing.protein100
            case .carbs:   total += ing.netCarbs100
            case .fat:     total += ing.fat100
            case .cost:    total += costPer100(ing)
            case .name:    break
            }
        }
        return total
    }

    private func sortedComposites() -> [FoodComposite] {
        if sortBy == .name {
            return foodCompositeMgr.composites.sorted { $0.name < $1.name }
        }
        return foodCompositeMgr.composites.sorted {
            compositeMetric($0) > compositeMetric($1)
        }
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


    // Prep page color: green only when this food/ingredient is in
    // the meal list (whether the meal row is active or inactive);
    // black otherwise. Mirrors the meal page's membership, not the
    // foodActive flag.
    private func statusColor(for ingredient: Ingredient) -> Color {
        isInMeal(ingredient) ? Color.theme.manual : Color.theme.blackWhite
    }


    // Prep tap: flip this ingredient's active-in-its-Food state.
    private func toggleFoodActive(_ ingredient: Ingredient) {
        ingredientMgr.toggleFoodActive(name: ingredient.name)
    }


    // Toggle the ingredient in/out of the meal:
    //   black -> green  (added to meal, active: true)
    //   green -> black  (removed from meal)
    //
    // No-op for meats: they're owned by the Proteins picker. The
    // chevron still navigates to IngredientEdit so the meat's data
    // is reachable.
    private func promote(_ ingredient: Ingredient) {
        if foodMgr.isMeat(ingredient) { return }
        let key = mealKey(ingredient)
        if let mi = mealIngredientMgr.getByName(name: key) {
            mealIngredientMgr.delete(mi)
        } else if ingredient.foodName.isEmpty {
            mealIngredientMgr.create(name: ingredient.name,
                                     amount: foodMgr.effectiveDefaultAmount(for: ingredient),
                                     active: true,
                                     isSupplement: foodMgr.isSupplement(ingredient))
        } else {
            // The meal row is the Food; the ingredient resolves
            // through the Food's current (global). Start amount from
            // the current ingredient's effective preset (ingredient
            // override wins, else the Food-level default).
            let member = foodMgr.getByName(name: ingredient.foodName)?.currentIngredientName
                ?? ingredient.name
            let amount = ingredientMgr.getByName(name: member)
                .map { foodMgr.effectiveDefaultAmount(for: $0) } ?? 0
            mealIngredientMgr.create(name: ingredient.foodName,
                                     amount: amount,
                                     active: true,
                                     isSupplement: foodMgr.isSupplement(ingredient))
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
    let existing: FoodComposite?
    let onSave: (String, [CompositeComponent]) -> Void
    let onDelete: (() -> Void)?

    @State private var name = ""
    @State private var included: Set<String> = []
    @State private var amounts: [String: Double] = [:]

    init(existing: FoodComposite? = nil,
         foods: [String],
         onSave: @escaping (String, [CompositeComponent]) -> Void,
         onDelete: (() -> Void)? = nil) {
        self.existing = existing
        self.foods = foods
        self.onSave = onSave
        self.onDelete = onDelete
    }

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
                if existing != nil, let onDelete = onDelete {
                    Section {
                        Button(role: .destructive) {
                            onDelete()
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Label("Delete composite", systemImage: "trash")
                              .foregroundColor(Color.theme.red)
                        }
                    }
                }
            }
              .navigationTitle(existing == nil ? "New composite" : "Edit composite")
              .navigationBarTitleDisplayMode(.inline)
              .onAppear {
                  guard let e = existing, name.isEmpty, included.isEmpty else { return }
                  name = e.name
                  included = Set(e.components.map { $0.foodName })
                  amounts = Dictionary(uniqueKeysWithValues:
                      e.components.map { ($0.foodName, $0.amount) })
              }
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
