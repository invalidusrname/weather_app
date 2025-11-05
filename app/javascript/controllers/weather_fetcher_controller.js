import { Controller } from "@hotwired/stimulus";

const API_URL = "https://api.bigdatacloud.net/data/reverse-geocode-client";

export default class extends Controller {
  static targets = ["input"];

  async updateZipFromGeo() {
    this.inputTarget.value = "Fetching...";

    try {
      const zip = await this.determineZipCode();
      this.inputTarget.value = zip;
    } catch (err) {
      console.error("Error:", err.message);
      this.inputTarget.value = "";
    }
  }

  async determineZipCode() {
    if (!navigator.geolocation) {
      throw new Error("Geolocation is not supported by this browser.");
    }

    const position = await new Promise((resolve, reject) => {
      navigator.geolocation.getCurrentPosition(resolve, reject, {
        enableHighAccuracy: true,
        timeout: 5000,
        maximumAge: 0,
      });
    });

    const { latitude, longitude } = position.coords;

    const url = new URL(API_URL);
    url.search = new URLSearchParams({ latitude, longitude, localityLanguage: "en" });

    const response = await fetch(url);

    if (!response.ok) {
      throw new Error("Failed to fetch zip code.");
    }

    const data = await response.json();
    const zipCode = data.postcode || "Zip code not found";

    return zipCode;
  }
}
