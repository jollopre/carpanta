import '@github/details-dialog-element/dist/index.css'
import '@github/details-dialog-element/dist/index'
import { Application, Controller } from 'stimulus'

class DeferredDetailsController extends Controller {
  static values = { url: String }
  static targets = ['fragment']

  connect() {
    const observer = new MutationObserver(this.openChanged.bind(this));
    observer.observe(this.element, { attributeFilter: ['open'], attributeOldValue: true });
  }

  disconnect() {
    /* observer.disconnect(); */
    console.log('TODO disconnect observer');
  }

  openChanged(mutationList, observer) {
    mutationList.forEach((mutation) => {
      if (mutation.type == 'attributes') {
        if (mutation.oldValue == null) {
          this.load();
          console.log('details opened');
        } else {
          this.unload();
          console.log('details closed');
        }
      }
    });
  }

  load(event) {
    fetch(this.urlValue)
      .then(response => response.text())
      .then((html) => {
        if (this.hasFragmentTarget) {
          this.fragmentTarget.innerHTML = html
        }
      })
  }

  unload() {
    if (this.hasFragmentTarget) {
      this.fragmentTarget.innerHTML = ''
    }
  }
}

const application = Application.start();
application.register("deferred-details", DeferredDetailsController);
