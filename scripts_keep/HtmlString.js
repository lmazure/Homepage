export class HtmlString {
    constructor() {
        this.html = "";
    }
    static buildEmpty() {
        const that = new HtmlString();
        return that;
    }
    static buildFromString(str) {
        const that = new HtmlString();
        that.appendString(str);
        return that;
    }
    static buildFromTag(tag, content, ...attributes) {
        const that = new HtmlString();
        that.performTagAppending(tag, content, attributes);
        return that;
    }
    getHtml() {
        return this.html;
    }
    isEmpty() {
        return (this.html.length === 0);
    }
    appendString(str) {
        this.html += (typeof str === "string") ? HtmlString.escape(str) : str.getHtml();
        return this;
    }
    appendEmptyTag(tag) {
        this.html += "<" + tag + ">";
        return this;
    }
    appendTag(tag, content, ...attributes) {
        this.performTagAppending(tag, content, attributes);
        return this;
    }
    performTagAppending(tag, content, attributes) {
        if ((attributes.length % 2) !== 0) {
            throw "illegal call to HtmlString.performTagAppending()";
        }
        let str = "<" + tag;
        for (let i = 0; i < attributes.length; i += 2) {
            str += " " + attributes[i] + "=\"" + HtmlString.escapeAttributeValue(attributes[i + 1]) + "\"";
        }
        str += ">"
            + ((typeof content === "string") ? HtmlString.escape(content) : content.getHtml())
            + "</"
            + tag
            + ">";
        this.html += str;
    }
    static escape(unsafe) {
        return unsafe
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");
    }
    static escapeAttributeValue(unsafe) {
        return unsafe.replace(/"/g, "&quot;");
    }
}
//# sourceMappingURL=HtmlString.js.map