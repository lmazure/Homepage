/// <reference path ="lib/google.analytics.d.ts"/>
import { HtmlString } from "./HtmlString.js";
import { DataLoader } from "./DataLoader.js";
import { ContentBuilder } from "./ContentBuilder.js";
import { Popup } from "./Popup.js";
// ---------------------------------------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------------------------------------
function escapeHtml(unsafe) {
    return unsafe.replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;");
}
// ---------------------------------------------------------------------------------------------------------------
window.create_index = () => {
    let letters = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    let w = 100.0 / letters.length;
    let str = '<table id="navigationBar" width="100%"><TR>';
    for (let i = 0; i < letters.length; i++) {
        str += '<td align="center" width="'
            + w
            + '%"><a href="#'
            + letters.charAt(i)
            + '">'
            + letters.charAt(i)
            + "</a></td>";
    }
    str += "<tr></table>";
    document.body.insertAdjacentHTML("afterbegin", str);
};
// ---------------------------------------------------------------------------------------------------------------
window.do_email = () => {
    window.location.href = "mailto:"
        + "lmazure.website%40gmail.com"
        + "?subject="
        + encodeURIComponent("about the '"
            + document.title
            + "' page");
};
// ---------------------------------------------------------------------------------------------------------------
window.display_search = () => {
    const searchPanel = document.getElementById("searchPanel");
    if (isHidden(searchPanel)) {
        searchPanel.style.display = "block";
        scrollTo(0, document.body.scrollHeight);
        const searchText = document.getElementById("searchText");
        searchText.focus();
    }
    else {
        searchPanel.style.display = "none";
    }
};
// ---------------------------------------------------------------------------------------------------------------
window.do_search = () => {
    let request = "http://www.google.com/search?as_sitesearch=mazure.fr&q=";
    const terms = document.getElementById("searchText").value.split(" ");
    for (let i = 0; i < terms.length; i++) {
        if (terms[i] !== "") { // to avoid additional space characters
            if (i > 0) {
                request += "+";
            }
            request += terms[i];
        }
    }
    open(request, "_blank");
};
window.onload = () => {
    if (typeof postInitialize === "function") {
        postInitialize();
    }
};
// ---------------------------------------------------------------------------------------------------------------
let popup = null;
let personPopupAuthors = null;
window.do_person = (event, author) => {
    event.stopPropagation();
    if (personPopupAuthors == null) {
        const loader = new DataLoader((authors, articles, links, referringPages, keywords) => {
            personPopupAuthors = authors;
            window.do2_person(event, author);
        });
    }
    else {
        window.do2_person(event, author);
    }
};
window.do2_person = (event, author) => {
    if (popup === null) {
        popup = new Popup();
    }
    const description = HtmlString.buildFromTag("h1", ContentBuilder.authorToHtmlString(author));
    let links = HtmlString.buildEmpty();
    let articles = HtmlString.buildEmpty();
    for (let a of personPopupAuthors) {
        if ((a.namePrefix === author.namePrefix) &&
            (a.firstName === author.firstName) &&
            (a.middleName === author.middleName) &&
            (a.lastName === author.lastName) &&
            (a.nameSuffix === author.nameSuffix) &&
            (a.givenName === author.givenName)) {
            if (a.links !== undefined) {
                for (let link of a.links) {
                    links.appendTag("li", ContentBuilder.linkToHtmlString(link));
                }
            }
            for (let art of a.articles) {
                articles.appendTag("li", ContentBuilder.linkToHtmlString(art.links[0]));
            }
        }
    }
    if (!links.isEmpty()) {
        description.appendTag("h2", "Links");
        description.appendTag("ul", links);
    }
    if (!articles.isEmpty()) {
        description.appendTag("h2", "Articles");
        description.appendTag("ul", articles);
    }
    popup.display(event, description);
};
// ---------------------------------------------------------------------------------------------------------------
let keywordPopupKeywords = null;
window.do_keyword = (event, keyId) => {
    event.stopPropagation();
    if (personPopupAuthors == null) {
        const loader = new DataLoader((authors, articles, links, referringPages, keywords) => {
            keywordPopupKeywords = keywords;
            window.do2_keyword(event, keyId);
        });
    }
    else {
        window.do2_keyword(event, keyId);
    }
};
window.do2_keyword = (event, keyId) => {
    if (popup === null) {
        popup = new Popup();
    }
    const description = HtmlString.buildFromTag("h1", keyId);
    let links = HtmlString.buildEmpty();
    let articles = HtmlString.buildEmpty();
    for (let k of keywordPopupKeywords) {
        if (k.id === keyId) {
            if (k.links !== undefined) {
                for (let link of k.links) {
                    links.appendTag("li", ContentBuilder.linkToHtmlString(link));
                }
            }
            for (let art of k.articles) {
                articles.appendTag("li", ContentBuilder.linkToHtmlString(art.links[0]));
            }
        }
    }
    if (!links.isEmpty()) {
        description.appendTag("h2", "Links");
        description.appendTag("ul", links);
    }
    if (!articles.isEmpty()) {
        description.appendTag("h2", "Articles");
        description.appendTag("ul", articles);
    }
    popup.display(event, description);
};
// ---------------------------------------------------------------------------------------------------------------
function isHidden(element) {
    const style = window.getComputedStyle(element);
    return (style.display === "none");
}

//# sourceMappingURL=common.js.map
