import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hand"
export default class extends Controller {
  static targets = [ "card", 'cardContainer' ]
  
  sort() {

    const sortedArray = this.cardTargets.sort((a, b) => {
      const valueA = parseInt(a.dataset.value)
      const valueB = parseInt(b.dataset.value)
      return valueA - valueB; // For ascending order
    });

    const playingCards = document.querySelector('.playing-cards')
    sortedArray.forEach(card => {
      console.log('sorting...')
      this.cardContainerTarget.appendChild(card)
    });
  }
}
