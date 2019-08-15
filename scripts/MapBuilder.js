import HtmlString from "./HtmlString.js";
export class MapBuilder {
    constructor() {
        this.divCounter = 0;
    }
    buildMap() {
        const mapRequest = new XMLHttpRequest();
        const that = this;
        mapRequest.onreadystatechange = function () {
            if (this.readyState === 4 && this.status === 200) {
                const myObj = JSON.parse(this.responseText);
                let page = null;
                if (window.location.search.indexOf("?page=") === 0) {
                    page = window.location.search.substring(6);
                }
                that.initNodeOpenStatus(myObj.root, page);
                document.getElementById("content").innerHTML = that.buildNodeText(myObj.root, 0, page).getHtml();
            }
        };
        mapRequest.open("GET", "../content/map.json");
        mapRequest.send();
    }
    handleNodeClick(index) {
        const spanElement = document.getElementById(MapBuilder.spanDivName + index);
        const toggleElement = document.getElementById(MapBuilder.toggleDivName + index);
        if (window.getComputedStyle(spanElement).display === "none") {
            // node is hidden -> show it
            spanElement.style.display = "block";
            toggleElement.innerHTML = MapBuilder.openedNodeSymbol;
        }
        else {
            // node is visible -> hide it
            spanElement.style.display = "none";
            toggleElement.innerHTML = MapBuilder.closedNodeSymbol;
        }
        return (false);
    }
    initNodeOpenStatus(node, page) {
        let oneChildIsOpen = false;
        if (node.children !== undefined) {
            for (let child of node.children) {
                oneChildIsOpen = oneChildIsOpen || this.initNodeOpenStatus(child, page);
            }
        }
        if (node.page === page) {
            node.open = true;
        }
        else {
            node.open = oneChildIsOpen;
        }
        return node.open;
    }
    buildNodeText(node, depth, page) {
        const str = HtmlString.buildEmpty();
        for (let i = 0; i < depth; i++) {
            str.appendString("\u00A0\u00A0\u00A0\u00A0");
        }
        if (node.page === undefined) {
            str.appendString(node.title);
        }
        else {
            str.appendTag("a", node.title, "href", "../" + node.page, "title", "language: " + node.languages.join() + " | format: " + node.formats.join(), "target", "_self", "style", (node.page === page ? "font-weight: bold" : ""));
        }
        if (node.children === undefined) {
            str.appendEmptyTag("br");
        }
        else {
            const counter = this.divCounter;
            this.divCounter++;
            str.appendTag("a", node.open ? MapBuilder.openedNodeSymbol : MapBuilder.closedNodeSymbol, "onclick", "window.handleMapNodeClick(" + counter + ")", "id", MapBuilder.toggleDivName + counter, "style", "cursor: pointer");
            str.appendEmptyTag("br");
            const childStr = HtmlString.buildEmpty();
            for (let child of node.children) {
                childStr.appendString(this.buildNodeText(child, depth + 1, page));
            }
            str.appendTag("span", childStr, "id", MapBuilder.spanDivName + counter, "style", "display: " + (node.open ? "initial" : "none"));
        }
        return str;
    }
}
MapBuilder.openedNodeSymbol = "\u25BC";
MapBuilder.closedNodeSymbol = "\u25BA";
MapBuilder.spanDivName = "spanDiv";
MapBuilder.toggleDivName = "toggleDiv";
window.handleMapNodeClick = (index) => {
    MapBuilder.prototype.handleNodeClick(index);
};

//# sourceMappingURL=MapBuilder.js.map
