export class Popup {
    constructor() {
        this.popup = document.createElement("div");
        this.popup.style.width = "40%";
        this.popup.style.height = "40%";
        this.popup.onclick = function (e) { e.stopPropagation(); };
        this.popup.classList.add("keywordPopup");
        document.getElementById("footer").insertAdjacentElement("afterend", this.popup);
    }
    display(event, description) {
        window.addEventListener("click", (e) => this.clickHandler(e));
        window.addEventListener("keyup", (e) => this.keyupHandler(e));
        this.popup.innerHTML = description.getHtml();
        if ((event.clientY + this.popup.offsetHeight) < document.documentElement.clientHeight) {
            this.popup.style.top = event.pageY + "px";
        }
        else {
            this.popup.style.top = (event.pageY - this.popup.offsetHeight) + "px";
        }
        if ((event.clientX + this.popup.offsetWidth) < document.documentElement.clientWidth) {
            this.popup.style.left = event.pageX + "px";
        }
        else {
            this.popup.style.left = (event.pageX - this.popup.offsetWidth) + "px";
        }
        this.popup.scrollTop = 0;
        this.popup.style.visibility = "visible";
    }
    clickHandler(e) {
        this.undisplay();
    }
    keyupHandler(e) {
        if (e.key === "Escape") {
            this.undisplay();
        }
    }
    undisplay() {
        window.removeEventListener("click", this.clickHandler);
        window.removeEventListener("keyup", this.keyupHandler);
        this.popup.style.visibility = "hidden";
    }
}

//# sourceMappingURL=Popup.js.map
