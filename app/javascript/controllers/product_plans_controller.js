import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["planFields", "container"]

  connect() {
    console.log("Product plans controller connected")
  }

  addPlan(event) {
    event.preventDefault()

    const container = this.containerTarget
    const newIndex = new Date().getTime() // Use timestamp for unique IDs

    // Clone the last plan field or create a new one
    const template = this.createPlanTemplate(newIndex)

    // Insert before the empty state if it exists
    const emptyState = container.querySelector(".empty-state")
    if (emptyState) {
      emptyState.remove()
    }

    container.insertAdjacentHTML('beforeend', template)
  }

  removePlan(event) {
    event.preventDefault()

    const planField = event.target.closest(".product-plan-fields")
    const destroyField = planField.querySelector(".plan-destroy-field")

    if (destroyField) {
      // Mark for destruction if it's a persisted record
      destroyField.value = "1"
      planField.style.display = "none"
    } else {
      // Remove from DOM if it's a new record
      planField.remove()
    }

    // Show empty state if no plans remain visible
    const visiblePlans = document.querySelectorAll(".product-plan-fields:not([style*='display: none'])")
    if (visiblePlans.length === 0) {
      this.showEmptyState()
    }
  }

  createPlanTemplate(index) {
    return `
      <div class="product-plan-fields card mbe-4" data-product-plans-target="planFields">
        <div class="flex items-center justify-between mbe-3">
          <div class="flex items-center gap-2">
            <h5 class="text-lg font-semibold">New Plan</h5>
          </div>

          <div class="flex items-center gap-3">
            <div class="flex items-center gap-2">
              <label for="product_product_plans_attributes_${index}_status" class="text-sm">Active</label>
              <input type="checkbox" name="product[product_plans_attributes][${index}][status]" id="product_product_plans_attributes_${index}_status" value="active" checked="checked" class="switch">
            </div>

            <a href="#" class="btn btn--icon btn--danger" data-action="click->product-plans#removePlan">
              <span class="icon icon--trash" aria-hidden="true"></span>
            </a>
          </div>
        </div>

        <div class="separator mb-3" aria-hidden="true"></div>

        <div class="grid gap-4 grid-cols-1 lg:grid-cols-3">
          <div class="form-price">
            <label for="product_product_plans_attributes_${index}_price">Price</label>
            <div class="input-group">
              <input type="text" name="product[product_plans_attributes][${index}][price]" id="product_product_plans_attributes_${index}_price" placeholder="0" class="input" inputmode="decimal" data-controller="inputmask" data-maska-number-fraction="2" data-maska-number-unsigned="true">
              <span class="input-addon">PHP</span>
            </div>
            <p class="text-xs text-gray-500 mt-1">Amount in cents</p>
          </div>

          <div class="form-interval">
            <label for="product_product_plans_attributes_${index}_interval">Billing Interval</label>
            <select name="product[product_plans_attributes][${index}][interval]" id="product_product_plans_attributes_${index}_interval" class="input">
              <option value="">Select interval</option>
              <option value="monthly">Monthly</option>
              <option value="yearly">Yearly</option>
              <option value="daily">Daily</option>
            </select>
          </div>

          <div class="form-interval-count">
            <label for="product_product_plans_attributes_${index}_interval_count">Interval Count</label>
            <input type="number" name="product[product_plans_attributes][${index}][interval_count]" id="product_product_plans_attributes_${index}_interval_count" placeholder="1" class="input" min="1">
            <p class="text-xs text-gray-500 mt-1">e.g. 3 for quarterly</p>
          </div>

          <div class="form-currency">
            <label for="product_product_plans_attributes_${index}_price_currency">Currency</label>
            <input type="text" name="product[product_plans_attributes][${index}][price_currency]" id="product_product_plans_attributes_${index}_price_currency" value="PHP" class="input">
          </div>
        </div>
      </div>
    `
  }

  showEmptyState() {
    const container = this.containerTarget
    container.insertAdjacentHTML('beforeend', `
      <div class="empty-state text-center py-8">
        <span class="icon icon--inbox" aria-hidden="true" style="--icon-size: 3rem; opacity: 0.3;"></span>
        <p class="text-gray-500 mt-2">No pricing plans yet. Click "Add Plan" to create one.</p>
      </div>
    `)
  }
}
