import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="address"
export default class extends Controller {
  static targets = [
    "region", "regionText",
    "province", "provinceText",
    "city", "cityText",
    "barangay", "barangayText"
  ]

  connect() {
    this.loadRegions()
  }

  async loadRegions() {
    const dropdown = this.regionTarget
    dropdown.innerHTML = '<option selected="true" disabled>Choose Region</option>'
    dropdown.selectedIndex = 0

    try {
      const response = await fetch('/address_json/region.json')
      const data = await response.json()

      data.forEach(entry => {
        const option = document.createElement('option')
        option.value = entry.region_code
        option.textContent = entry.region_name
        dropdown.appendChild(option)
      })
    } catch (error) {
      console.error('Error loading regions:', error)
    }
  }

  async fillProvinces(event) {
    const regionCode = event.target.value
    const regionText = event.target.options[event.target.selectedIndex].text

    // Set region text
    this.regionTextTarget.value = regionText

    // Clear dependent fields
    this.provinceTextTarget.value = ''
    this.cityTextTarget.value = ''
    this.barangayTextTarget.value = ''

    // Reset province dropdown
    const provinceDropdown = this.provinceTarget
    provinceDropdown.innerHTML = '<option selected="true" disabled>Choose State/Province</option>'
    provinceDropdown.selectedIndex = 0

    // Reset city dropdown
    const cityDropdown = this.cityTarget
    cityDropdown.innerHTML = '<option selected="true" disabled></option>'
    cityDropdown.selectedIndex = 0

    // Reset barangay dropdown
    const barangayDropdown = this.barangayTarget
    barangayDropdown.innerHTML = '<option selected="true" disabled></option>'
    barangayDropdown.selectedIndex = 0

    try {
      const response = await fetch('/address_json/province.json')
      const data = await response.json()

      // Filter by region code
      const filtered = data.filter(value => value.region_code == regionCode)

      // Sort alphabetically
      filtered.sort((a, b) => a.province_name.localeCompare(b.province_name))

      // Populate dropdown
      filtered.forEach(entry => {
        const option = document.createElement('option')
        option.value = entry.province_code
        option.textContent = entry.province_name
        provinceDropdown.appendChild(option)
      })
    } catch (error) {
      console.error('Error loading provinces:', error)
    }
  }

  async fillCities(event) {
    const provinceCode = event.target.value
    const provinceText = event.target.options[event.target.selectedIndex].text

    // Set province text
    this.provinceTextTarget.value = provinceText

    // Clear dependent fields
    this.cityTextTarget.value = ''
    this.barangayTextTarget.value = ''

    // Reset city dropdown
    const cityDropdown = this.cityTarget
    cityDropdown.innerHTML = '<option selected="true" disabled>Choose city/municipality</option>'
    cityDropdown.selectedIndex = 0

    // Reset barangay dropdown
    const barangayDropdown = this.barangayTarget
    barangayDropdown.innerHTML = '<option selected="true" disabled></option>'
    barangayDropdown.selectedIndex = 0

    try {
      const response = await fetch('/address_json/city.json')
      const data = await response.json()

      // Filter by province code
      const filtered = data.filter(value => value.province_code == provinceCode)

      // Sort alphabetically
      filtered.sort((a, b) => a.city_name.localeCompare(b.city_name))

      // Populate dropdown
      filtered.forEach(entry => {
        const option = document.createElement('option')
        option.value = entry.city_code
        option.textContent = entry.city_name
        cityDropdown.appendChild(option)
      })
    } catch (error) {
      console.error('Error loading cities:', error)
    }
  }

  async fillBarangays(event) {
    const cityCode = event.target.value
    const cityText = event.target.options[event.target.selectedIndex].text

    // Set city text
    this.cityTextTarget.value = cityText

    // Clear barangay text
    this.barangayTextTarget.value = ''

    // Reset barangay dropdown
    const barangayDropdown = this.barangayTarget
    barangayDropdown.innerHTML = '<option selected="true" disabled>Choose barangay</option>'
    barangayDropdown.selectedIndex = 0

    try {
      const response = await fetch('/address_json/barangay.json')
      const data = await response.json()

      // Filter by city code
      const filtered = data.filter(value => value.city_code == cityCode)

      // Sort alphabetically
      filtered.sort((a, b) => a.brgy_name.localeCompare(b.brgy_name))

      // Populate dropdown
      filtered.forEach(entry => {
        const option = document.createElement('option')
        option.value = entry.brgy_code
        option.textContent = entry.brgy_name
        barangayDropdown.appendChild(option)
      })
    } catch (error) {
      console.error('Error loading barangays:', error)
    }
  }

  updateBarangayText(event) {
    const barangayText = event.target.options[event.target.selectedIndex].text
    this.barangayTextTarget.value = barangayText
  }
}
