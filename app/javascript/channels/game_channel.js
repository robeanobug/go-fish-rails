import consumer from "./consumer"
import { Controller } from "@hotwired/stimulus"

consumer.subscriptions.create(
{
  channel: "GameChannel", 
  id: document.getElementById('game_id').dataset.id
},
{
  connected() {
    console.log('Connected to Actioncable')
  },

  disconnected() {
    console.log('Disconnected from Actioncable')
  },

  received(data) {
    this.appendLine(data)
    console.log('Received data')
    // console.log(data)
  },

  appendLine(data) {
    const element = document.querySelector('.feed__output')
    const html = this.createMessage(data)
    if (element) {
      element.insertAdjacentHTML("afterbegin", html)
    }
  },

  createMessage(data) {
    return `
      <div class="feed__bubble feed__bubble--main">
      <span>${data['question']}</span>
      </div>
      <div class="feed__bubble feed__bubble--alert">
      <span>${data['response']}</span>
      </div>
      <div class="feed__bubble feed__bubble--sub">
      <span>${data['action']}</span>
      </div>
      `
  }
});

// export default class extends Controller {
//   static targets = ["game"];
//   connect() {
//     this.subscription = consumer.subscriptions.create({
//       channel: "GameChannel",
//       id: this.data.get("id"),
//     },
//     {
//       connected: this._connected.bind(this),
//       disconnected: this._disconnected.bind(this),
//       received: this._received.bind(this),
//     });
//   }
//   _connected() {}
//   _disconnected() {}
//   _received(data) {
//     window.location.reload()
//   }
// }