import { HtmlString } from "./HtmlString.js";
import { DataLoader } from "./DataLoader.js";
var ContentSort;
(function (ContentSort) {
    ContentSort["Article"] = "article";
    ContentSort["Author"] = "author";
    ContentSort["Link"] = "link";
})(ContentSort || (ContentSort = {}));
export class ContentBuilder {
    constructor() {
        switch (window.location.search) {
            case "?sort=link": // TODO utiliser linkParameterString
                this.sort = ContentSort.Link;
                break;
            case "?sort=author": // TODO utiliser authorParameterString
                this.sort = ContentSort.Author;
                break;
            default:
                this.sort = ContentSort.Article;
        }
        ContentBuilder.instance = this;
    }
    buildContent() {
        const loader = new DataLoader((authors, articles, links, referringPages) => {
            this.authors = authors;
            this.articles = articles;
            this.links = links;
            this.referringPages = referringPages;
            this.updateContent();
        });
    }
    updateContent() {
        document.getElementById("content").innerHTML = this.buildContentText().getHtml();
        this.setGoToMapHref();
    }
    setGoToMapHref() {
        const goToMapHref = document.getElementById("goToMap")
            .getAttribute("href")
            .replace(/\/content\.html.*/, "/content.html?sort=" + this.sort);
        document.getElementById("goToMap")
            .setAttribute("href", goToMapHref);
    }
    buildContentText() {
        switch (this.sort) {
            case ContentSort.Article:
                return this.buildContentTextForArticleSort();
            case ContentSort.Author:
                return this.buildContentTextForAuthorSort();
            case ContentSort.Link:
                return this.buildContentTextForLinkSort();
        }
    }
    switchSort(sort) {
        switch (sort) {
            case ContentSort.Article:
                ContentBuilder.instance.sort = ContentSort.Article;
                break;
            case ContentSort.Author:
                ContentBuilder.instance.sort = ContentSort.Author;
                break;
            case ContentSort.Link:
                ContentBuilder.instance.sort = ContentSort.Link;
                break;
        }
        ContentBuilder.instance.updateContent();
    }
    buildContentTextForArticleSort() {
        const headerCells = HtmlString.buildFromTag("th", "title") // TODO use constants for the headers
            // including in the getXxxHeader methods
            .appendTag("th", ContentBuilder.getAuthorsHeader())
            .appendTag("th", "date")
            .appendTag("th", ContentBuilder.getUrlHeader())
            .appendTag("th", "language")
            .appendTag("th", "format")
            .appendTag("th", "duration")
            .appendTag("th", "referring page");
        const row = HtmlString.buildFromTag("tr", headerCells);
        for (let article of this.articles) {
            const title = ContentBuilder.getTitleCellFromLink(article.links[0]);
            const authors = ContentBuilder.getAuthorsCellFromArticle(article);
            const date = ContentBuilder.getDateCellFromArticle(article);
            const urls = ContentBuilder.getUrlCellFromArticle(article);
            const languages = ContentBuilder.getLanguageCellFromLink(article.links[0]);
            const formats = ContentBuilder.getFormatCellFromLink(article.links[0]);
            const duration = ContentBuilder.getDurationCellFromLink(article.links[0]);
            const referringPage = this.getReferringPageCellFromArticle(article);
            const cells = HtmlString.buildFromTag("td", title)
                .appendTag("td", authors)
                .appendTag("td", date)
                .appendTag("td", urls)
                .appendTag("td", languages)
                .appendTag("td", formats)
                .appendTag("td", duration)
                .appendTag("td", referringPage);
            row.appendTag("tr", cells);
        }
        const table = HtmlString.buildFromTag("table", row, "class", "table");
        const full = HtmlString.buildFromString("number of articles: " + this.articles.length)
            .appendString(table);
        return full;
    }
    buildContentTextForAuthorSort() {
        const headerCells = HtmlString.buildFromTag("th", "authors")
            .appendTag("th", ContentBuilder.getTitleHeader())
            .appendTag("th", "co-authors")
            .appendTag("th", "date")
            .appendTag("th", ContentBuilder.getUrlHeader())
            .appendTag("th", "language")
            .appendTag("th", "format")
            .appendTag("th", "duration")
            .appendTag("th", "referring page");
        const row = HtmlString.buildFromTag("tr", headerCells);
        for (let author of this.authors) {
            let first = true;
            for (let article of author.articles) {
                const title = ContentBuilder.getTitleCellFromLink(article.links[0]);
                const coauthors = ContentBuilder.getCoauthorsCellFromArticle(article, author);
                const date = ContentBuilder.getDateCellFromArticle(article);
                const urls = ContentBuilder.getUrlCellFromArticle(article);
                const languages = ContentBuilder.getLanguageCellFromLink(article.links[0]);
                const formats = ContentBuilder.getFormatCellFromLink(article.links[0]);
                const duration = ContentBuilder.getDurationCellFromLink(article.links[0]);
                const referringPage = this.getReferringPageCellFromArticle(article);
                const cells = first ? HtmlString.buildFromTag("td", ContentBuilder.authorToHtmlString(author), "rowspan", author.articles.length.toString())
                    : HtmlString.buildEmpty();
                cells.appendTag("td", title)
                    .appendTag("td", coauthors)
                    .appendTag("td", date)
                    .appendTag("td", urls)
                    .appendTag("td", languages)
                    .appendTag("td", formats)
                    .appendTag("td", duration)
                    .appendTag("td", referringPage);
                row.appendTag("tr", cells);
                first = false;
            }
        }
        const table = HtmlString.buildFromTag("table", row, "class", "table");
        const full = HtmlString.buildFromString("number of authors: " + this.authors.length)
            .appendString(table);
        return full;
    }
    buildContentTextForLinkSort() {
        const headerCells = HtmlString.buildFromTag("th", "URL")
            .appendTag("th", ContentBuilder.getTitleHeader())
            .appendTag("th", ContentBuilder.getAuthorsHeader())
            .appendTag("th", "date")
            .appendTag("th", "language")
            .appendTag("th", "format")
            .appendTag("th", "duration")
            .appendTag("th", "referring page");
        const row = HtmlString.buildFromTag("tr", headerCells);
        for (let link of this.links) {
            const url = ContentBuilder.getUrlCellFromLink(link);
            const title = ContentBuilder.getTitleCellFromLink(link);
            const authors = ContentBuilder.getAuthorsCellFromArticle(link.article);
            const date = ContentBuilder.getDateCellFromArticle(link.article);
            const languages = ContentBuilder.getLanguageCellFromLink(link);
            const formats = ContentBuilder.getFormatCellFromLink(link);
            const duration = ContentBuilder.getDurationCellFromLink(link);
            const referringPage = this.getReferringPageCellFromArticle(link.article);
            const cells = HtmlString.buildFromTag("td", url)
                .appendTag("td", title)
                .appendTag("td", authors)
                .appendTag("td", date)
                .appendTag("td", languages)
                .appendTag("td", formats)
                .appendTag("td", duration)
                .appendTag("td", referringPage);
            row.appendTag("tr", cells);
        }
        const table = HtmlString.buildFromTag("table", row, "class", "table");
        const full = HtmlString.buildFromString("number of URLs: " + this.links.length)
            .appendString(table);
        return full;
    }
    static getTitleHeader() {
        return HtmlString.buildFromTag("a", "title", "href", "#", "onclick", "window.contentBuilderSwitchSort('" + ContentSort.Article + "')", "style", "cursor: pointer");
    }
    static getAuthorsHeader() {
        return HtmlString.buildFromTag("a", "authors", "href", "#", "onclick", "window.contentBuilderSwitchSort('" + ContentSort.Author + "')", "style", "cursor: pointer");
    }
    static getUrlHeader() {
        return HtmlString.buildFromTag("a", "URL", "href", "#", "onclick", "window.contentBuilderSwitchSort('" + ContentSort.Link + "')", "style", "cursor: pointer");
    }
    static getTitleCellFromLink(link) {
        const title = HtmlString.buildFromString(link.title);
        if (link.subtitle !== undefined) {
            title.appendString(" \u{2014} ")
                .appendString(link.subtitle.join(" \u{2014} "));
        }
        return title;
    }
    static getAuthorsCellFromArticle(article) {
        return ContentBuilder.getCoauthorsCellFromArticle(article, undefined);
    }
    static getCoauthorsCellFromArticle(article, author) {
        const authors = HtmlString.buildEmpty();
        if (article.authors !== undefined) {
            let flag = false;
            for (let a of article.authors) {
                if (a !== author) {
                    if (flag) {
                        authors.appendEmptyTag("br");
                    }
                    else {
                        flag = true;
                    }
                    authors.appendString(ContentBuilder.authorToHtmlString(a));
                }
            }
        }
        return authors;
    }
    static getDateCellFromArticle(article) {
        const date = (article.date !== undefined)
            ? HtmlString.buildFromString(ContentBuilder.dateToHtmlString(article.date))
            : HtmlString.buildEmpty();
        return date;
    }
    static getUrlCellFromArticle(article) {
        const urls = HtmlString.buildEmpty();
        let flag = false;
        for (let l of article.links) {
            if (flag) {
                urls.appendEmptyTag("br");
            }
            else {
                flag = true;
            }
            urls.appendString(ContentBuilder.getUrlCellFromLink(l));
        }
        return urls;
    }
    static getUrlCellFromLink(link) {
        return this.getTitleOrUrlFromLink(link, false);
    }
    static getTitleOrUrlFromLink(link, displayTitleInsteadOfUrl) {
        const url = HtmlString.buildFromTag("a", displayTitleInsteadOfUrl ? link.title + ((link.subtitle !== undefined) ? (" — " + link.subtitle) : "")
            : link.url, "href", link.url, "title", "language: "
            + link.languages.join(" ")
            + " | format: "
            + link.formats.join(" ")
            + ((link.duration === undefined)
                ? ""
                : (" | duration: " + ContentBuilder.durationToString(link.duration))), "target", (link.url.indexOf("javascript:") === 0) ? "_self" : "_blank");
        if (link.protection !== undefined) {
            url.appendString(ContentBuilder.protectionToHtmlString(link.protection));
        }
        if (link.status !== undefined) {
            url.appendString(ContentBuilder.statusToHtmlString(link.status));
        }
        return url;
    }
    static getLanguageCellFromLink(link) {
        const languages = HtmlString.buildEmpty();
        {
            let flag = false;
            for (let l of link.languages) {
                if (flag) {
                    languages.appendEmptyTag("br");
                }
                else {
                    flag = true;
                }
                languages.appendString(l);
            }
        }
        return languages;
    }
    static getFormatCellFromLink(link) {
        const formats = HtmlString.buildEmpty();
        {
            let flag = false;
            for (let l of link.formats) {
                if (flag) {
                    formats.appendEmptyTag("br");
                }
                else {
                    flag = true;
                }
                formats.appendString(l);
            }
        }
        return formats;
    }
    static getDurationCellFromLink(link) {
        const duration = (link.duration !== undefined) ? ContentBuilder.durationToHtmlString(link.duration)
            : HtmlString.buildEmpty();
        return duration;
    }
    getReferringPageCellFromArticle(article) {
        const referringPage = HtmlString.buildFromTag("a", article.page, "href", "../" + article.page, "title", "language: "
            + this.referringPages[article.page].languages.join()
            + " | format: "
            + this.referringPages[article.page].formats.join(), "target", "_self");
        return referringPage;
    }
    static authorToHtmlString(author) {
        let fullString = HtmlString.buildEmpty();
        fullString = this.appendSpaceAndPostfixToHtmlString(fullString, author.namePrefix);
        fullString = this.appendSpaceAndPostfixToHtmlString(fullString, author.firstName);
        fullString = this.appendSpaceAndPostfixToHtmlString(fullString, author.middleName);
        fullString = this.appendSpaceAndPostfixToHtmlString(fullString, author.lastName);
        fullString = this.appendSpaceAndPostfixToHtmlString(fullString, author.nameSuffix);
        return this.appendSpaceAndPostfixToHtmlString(fullString, author.givenName);
    }
    static linkToHtmlString(link) {
        return ContentBuilder.getTitleOrUrlFromLink(link, true);
    }
    static durationToHtmlString(duration) {
        return HtmlString.buildFromString(ContentBuilder.durationToString(duration));
    }
    static durationToString(duration) {
        if ((duration <= 0) || (duration >= 24 * 60 * 60)) {
            throw "illegal call to buildContentText.dateToHtmlString() (duration = " + duration + ")";
        }
        let hours = Math.floor(duration / 3600);
        let minutes = Math.floor((duration % 3600) / 60);
        let seconds = duration % 60;
        return ((hours > 0) ? (hours + "h ") : "")
            + (((hours > 0) || (minutes > 0)) ? (minutes + "m ") : "")
            + seconds + "s";
    }
    static dateToHtmlString(date) {
        if (date <= 9999) {
            return HtmlString.buildFromString("" + date);
        }
        else if (date <= 999999) {
            let year = Math.floor(date / 100);
            let month = date % 100;
            return ContentBuilder.monthToHtmlString(month)
                .appendString(" " + year);
        }
        else if (date <= 99999999) {
            let year = Math.floor(date / 10000);
            let month = Math.floor((date % 10000) / 100);
            let day = date % 100;
            return ContentBuilder.monthToHtmlString(month)
                .appendString(" ")
                .appendString(ContentBuilder.dayToHtmlString(day))
                .appendString(", " + year);
        }
        throw "illegal call to buildContentText.dateToHtmlString() (date = " + date + ")";
    }
    static dayToHtmlString(day) {
        switch (day) {
            case 1: return HtmlString.buildFromString("1").appendTag("sup", "st");
            case 21: return HtmlString.buildFromString("21").appendTag("sup", "st");
            case 31: return HtmlString.buildFromString("31").appendTag("sup", "st");
            case 2: return HtmlString.buildFromString("2").appendTag("sup", "nd");
            case 22: return HtmlString.buildFromString("22").appendTag("sup", "nd");
            case 3: return HtmlString.buildFromString("3").appendTag("sup", "rd");
            case 23: return HtmlString.buildFromString("23").appendTag("sup", "rd");
            default: return HtmlString.buildFromString("" + day).appendTag("sup", "th");
        }
    }
    static monthToHtmlString(month) {
        switch (month) {
            case 1: return HtmlString.buildFromString("January");
            case 2: return HtmlString.buildFromString("February");
            case 3: return HtmlString.buildFromString("March");
            case 4: return HtmlString.buildFromString("April");
            case 5: return HtmlString.buildFromString("May");
            case 6: return HtmlString.buildFromString("June");
            case 7: return HtmlString.buildFromString("July");
            case 8: return HtmlString.buildFromString("August");
            case 9: return HtmlString.buildFromString("September");
            case 10: return HtmlString.buildFromString("October");
            case 11: return HtmlString.buildFromString("November");
            case 12: return HtmlString.buildFromString("December");
        }
        throw "illegal call to buildContentText.monthToHtmlString() (month = " + month + ")";
    }
    static appendSpaceAndPostfixToHtmlString(str, postfix) {
        if (postfix !== undefined) {
            if (str.isEmpty()) {
                return str.appendString(postfix);
            }
            else {
                return str.appendString(" " + postfix);
            }
        }
        else {
            return str;
        }
    }
    static protectionToHtmlString(protection) {
        if (protection === "free_registration") {
            return HtmlString.buildFromTag("span", "\u{1f193}", "title", "free registration required");
        }
        if (protection === "payed_registration") {
            return HtmlString.buildFromTag("span", "\u{1f4b0}", "title", "payed registration required");
        }
        throw "illegal call to buildContentText.protectionToHtmlString() (unknown value = \"" + protection + "\")";
    }
    static statusToHtmlString(status) {
        if ((status === "dead") || (status === "zombie")) {
            return HtmlString.buildFromTag("span", "\u{2020}", "title", "dead link");
        }
        else if (status === "obsolete") {
            return HtmlString.buildFromTag("span", "\u{2021}", "title", "obsolete");
        }
        throw "illegal call to buildContentText.statusToHtmlString() (unknown value = \"" + status + "\")";
    }
}
window.contentBuilderSwitchSort = (sort) => {
    ContentBuilder.prototype.switchSort(sort);
};
//# sourceMappingURL=ContentBuilder.js.map