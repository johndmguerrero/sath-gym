import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="checkout"
export default class extends Controller {
  static targets = [
    "subtotalInput",
    "totalInput",
    "payingInput",
    "displaySubtotal",
    "displayTotal",
    "displayPaying",
    "displayChange",
    "summaryCard"
  ]

  connect() {
    this.updateDisplays()
  }

  updateDisplays() {
    const subtotal = this.getCentsValue(this.subtotalInputTarget)
    const total = this.getCentsValue(this.totalInputTarget)
    const paying = this.getCentsValue(this.payingInputTarget)
    const change = paying - total

    // Update display elements with formatted currency
    if (this.hasDisplaySubtotalTarget) {
      this.displaySubtotalTarget.textContent = this.formatCurrency(subtotal)
    }
    if (this.hasDisplayTotalTarget) {
      this.displayTotalTarget.textContent = this.formatCurrency(total)
    }
    if (this.hasDisplayPayingTarget) {
      this.displayPayingTarget.textContent = this.formatCurrency(paying)
    }
    if (this.hasDisplayChangeTarget) {
      this.displayChangeTarget.textContent = this.formatCurrency(change)
      this.updateChangeColor(change)
    }

    // Visual feedback for summary card
    if (this.hasSummaryCardTarget) {
      this.updateSummaryCard(change)
    }
  }

  getCentsValue(target) {
    // Use unmasked value from Maska if available, otherwise fall back to raw value
    const rawValue = target?.dataset?.maskRawValue || target?.value || '0'
    return parseFloat(rawValue.replace(/,/g, '')) || 0
  }

  formatCurrency(amount) {
    return '₱ ' + amount.toLocaleString('en-PH', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    })
  }

  updateChangeColor(change) {
    if (change < 0) {
      this.displayChangeTarget.classList.remove('text-green-600')
      this.displayChangeTarget.classList.add('text-red-600')
    } else {
      this.displayChangeTarget.classList.remove('text-red-600')
      this.displayChangeTarget.classList.add('text-green-600')
    }
  }

  updateSummaryCard(change) {
    if (change < 0) {
      this.summaryCardTarget.classList.remove('bg-gray-50')
      this.summaryCardTarget.classList.add('bg-red-50', 'border', 'border-red-200')
    } else {
      this.summaryCardTarget.classList.remove('bg-red-50', 'border', 'border-red-200')
      this.summaryCardTarget.classList.add('bg-gray-50')
    }
  }

}
