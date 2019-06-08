/// <reference path ="lib/jquery.d.ts"/>
/// <reference path ="lib/google.analytics.d.ts"/>
import HtmlString from "./HtmlString.js";
import { DataLoader } from "./DataLoader.js";
import ContentBuilder from "./ContentBuilder.js";
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
    $("body").prepend(str);
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
    $("#searchPanel").slideToggle({
        done: function () {
            if ($("#searchPanel").is(":visible")) {
                $("#searchPanel>#panel>#text").focus();
            }
        },
        progress: function () {
            scrollTo(0, document.body.scrollHeight);
        },
    });
};
// ---------------------------------------------------------------------------------------------------------------
window.do_search = () => {
    let request = "http://www.google.com/search?as_sitesearch=mazure.fr&q=";
    const terms = ($("#searchPanel>#panel>#text").val()).split(" ");
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
// ---------------------------------------------------------------------------------------------------------------
// rfc/<rfc-number>
// man/linux/<man-section-number>/<command>
// man/macosx/<man-section-number>/<command>
// man/x11/<man-section-number>/<command>
// j2se/<class>
// j2se/<class>/<method>
// clearcase/command
window.do_reference = (str) => {
    const a = str.split("/");
    let url = "?";
    if (a[0] === "rfc") {
        url = "http://www.ietf.org/rfc/rfc" + a[1] + ".txt";
    }
    else if (a[0] === "man" && a[1] === "linux") {
        url = "http://man7.org/linux/man-pages/man" + a[2].substr(0, 1) + "/" + a[3] + "." + a[2] + ".html";
    }
    else if (a[0] === "man" && a[1] === "macosx") {
        url = "https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man"
            + a[2]
            + "/"
            + a[3]
            + "."
            + a[2]
            + ".html";
    }
    else if (a[0] === "man" && a[1] === "x11") {
        url = "http://www.x.org/X11R6.8.2/doc/" + a[3] + "." + a[2] + ".html";
    }
    else if (a[0] === "j2se" && a.length === 2) {
        url = "http://java.sun.com/j2se/1.5.0/docs/api/" + a[1].replace(/\./g, "/") + ".html";
    }
    else if (a[0] === "j2se" && a.length === 3) {
        url = "http://java.sun.com/j2se/1.5.0/docs/api/" + a[1].replace(/\./g, "/") + ".html#" + escapeHtml(a[2]);
    }
    else if (a[0] === "clearcase" && a.length === 2) {
        url = "http://www.agsrhichome.bnl.gov/Controls/doc/ClearCaseEnv/v4.0doc/cpf_4.0/ccase_ux/ccref/"
            + a[1]
            + ".html";
    }
    window.open(url, "_blank");
};
window.onload = () => {
    const currdate = new Date();
    /* tslint:disable:no-string-literal */
    /* tslint:disable:semicolon */
    /* tslint:disable:no-unused-expression */
    // This code is from Google, so let's not modify it too much
    (function (i, s, o, g, r, a, m) {
        i["GoogleAnalyticsObject"] = r;
        i[r] = i[r] || function () {
            (i[r].q = i[r].q || []).push(arguments);
        }, i[r].l = 1 * currdate;
        a = s.createElement(o), m = s.getElementsByTagName(o)[0];
        a.async = 1;
        a.src = g;
        m.parentNode.insertBefore(a, m);
    })(window, document, "script", "//www.google-analytics.com/analytics.js", "ga");
    /* tslint:enable:no-unused-expression */
    /* tslint:enable:semicolon */
    /* tslint:enable:no-string-literal */
    ga("create", "UA-45789787-1", "auto");
    ga("send", "pageview");
    if (typeof postInitialize === "function") {
        postInitialize();
    }
};
// ---------------------------------------------------------------------------------------------------------------
let personPopup = null;
let personPopupAuthors = null;
window.do_person = (event, author) => {
    event.stopPropagation();
    if (personPopupAuthors == null) {
        const loader = new DataLoader((authors, articles, links, referringPages) => {
            personPopupAuthors = authors;
            // this.articles = articles;
            // this.links = links;
            // this.referringPages = referringPages;
            window.do2_person(event, author);
        });
    }
    else {
        window.do2_person(event, author);
    }
};
window.do2_person = (event, author) => {
    if (personPopup === null) {
        personPopup = document.createElement("div");
        personPopup.style.width = "40%";
        personPopup.style.height = "40%";
        personPopup.onclick = function (e) { e.stopPropagation(); };
        personPopup.classList.add("personPopup");
        document.getElementById("footer").insertAdjacentElement("afterend", personPopup);
    }
    const description = HtmlString.buildFromTag("h1", ContentBuilder.authorToHtmlString(author));
    let articles = HtmlString.buildEmpty();
    for (let a of personPopupAuthors) {
        if ((a.namePrefix === author.namePrefix) &&
            (a.firstName === author.firstName) &&
            (a.middleName === author.middleName) &&
            (a.lastName === author.lastName) &&
            (a.nameSuffix === author.nameSuffix) &&
            (a.givenName === author.givenName)) {
            for (let art of a.articles) {
                articles.appendTag("li", ContentBuilder.articleToHtmlString(art.links[0]));
            }
        }
    }
    description.appendTag("ul", articles);
    const clickHandler = function (e) {
        window.removeEventListener("click", clickHandler);
        personPopup.style.visibility = "hidden";
    };
    window.addEventListener("click", clickHandler);
    personPopup.innerHTML = description.getHtml();
    if ((event.clientY + personPopup.offsetHeight) < document.documentElement.clientHeight) {
        personPopup.style.top = event.pageY + "px";
    }
    else {
        personPopup.style.top = (event.pageY - personPopup.offsetHeight) + "px";
    }
    if ((event.clientX + personPopup.offsetWidth) < document.documentElement.clientWidth) {
        personPopup.style.left = event.pageX + "px";
    }
    else {
        personPopup.style.left = (event.pageX - personPopup.offsetWidth) + "px";
    }
    personPopup.style.visibility = "visible";
};
//# sourceMappingURL=common.js.map