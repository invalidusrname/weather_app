import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input"];

  async getZip() {
    this.inputTarget.value = "Fetching...";

    try {
      const zip = await this.getZipCode();
      this.inputTarget.value = zip;
    } catch (err) {
      console.error("Error:", err.message);
      this.inputTarget.value = "";
    }
  }

  async getZipCode() {
    if (!navigator.geolocation) {
      throw new Error("Geolocation is not supported by this browser.");
    }

    const position = await new Promise((resolve, reject) => {
      navigator.geolocation.getCurrentPosition(
        resolve,
        reject,
        { enableHighAccuracy: true, timeout: 5000, maximumAge: 0 }
      );
    });

    const { latitude, longitude } = position.coords;

    const response = await fetch(
      `https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${latitude}&longitude=${longitude}&localityLanguage=en`
    );

    if (!response.ok) {
      throw new Error("Failed to fetch zip code.");
    }

    const data = await response.json();
    const zipCode = data.postcode || "Zip code not found";

    return zipCode;
  }
}
