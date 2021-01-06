export class DataLoader {
    constructor(callback) {
        let mapRoot;
        const p1 = DataLoader.getJson("../content/author.json")
            .then((data) => { this.authors = data.authors; })
            .catch((error) => console.log("Failed to load author.json", error));
        const p2 = DataLoader.getJson("../content/article.json")
            .then((data) => { this.articles = data.articles; })
            .catch((error) => console.log("Failed to load article.json", error));
        const p3 = DataLoader.getJson("../content/map.json")
            .then((data) => { mapRoot = data.root; })
            .catch((error) => console.log("Failed to load map.json", error));
        const p4 = DataLoader.getJson("../content/keyword.json")
            .then((data) => { this.keywords = data.keywords; })
            .catch((error) => console.log("Failed to load keyword.json", error));
        const promises = [p1, p2, p3, p4];
        Promise.all(promises)
            .then(() => this.postprocessData(mapRoot))
            .then(() => callback(this.authors, this.articles, this.links, this.referringPages, this.keywords))
            .catch((error) => console.log("Failed to process data", error));
    }
    static getJson(url) {
        return new Promise(function (resolve, reject) {
            const request = new XMLHttpRequest();
            request.onload = function () {
                if (this.status === 200) {
                    resolve(JSON.parse(this.responseText));
                }
                else {
                    reject(Error(request.statusText));
                }
            };
            request.onerror = function () {
                reject(Error("Network Error"));
            };
            request.open("GET", url);
            request.send();
        });
    }
    postprocessData(rootNode) {
        this.links = [];
        for (let article of this.articles) {
            if (article.authorIndexes !== undefined) {
                article.authors = article.authorIndexes.map(i => this.authors[i]);
                // TODO delete article.authorIndexes
                for (let author of article.authors) {
                    if (author.articles === undefined) {
                        author.articles = [article];
                    }
                    else {
                        author.articles.push(article);
                    }
                }
            }
            for (let l of article.links) {
                l.article = article;
                this.links.push(l);
            }
        }
        for (let author of this.authors) {
            author.articles.sort(DataLoader.compareArticleByDate);
        }
        this.links.sort(function (l1, l2) {
            const u1 = l1.url.substring(l1.url.indexOf("://") + 1);
            const u2 = l2.url.substring(l2.url.indexOf("://") + 1);
            return u1.localeCompare(u2);
        });
        this.referringPages = [];
        this.postProcessData_InserReferingPage(rootNode);
        for (let keyword of this.keywords) {
            keyword.articles = keyword.articleIndexes.map(i => this.articles[i]);
            // TODO delete keyword.articleIndexes
        }
    }
    postProcessData_InserReferingPage(node) {
        this.referringPages[node.page] = node;
        if (node.children !== undefined) {
            for (let c of node.children) {
                this.postProcessData_InserReferingPage(c);
            }
        }
    }
    getAuthor(author) {
        for (let a of this.authors) {
            if ((a.namePrefix === author.namePrefix) &&
                (a.firstName === author.firstName) &&
                (a.middleName === author.middleName) &&
                (a.lastName === author.lastName) &&
                (a.nameSuffix === author.nameSuffix) &&
                (a.givenName === author.givenName)) {
                return a;
            }
        }
        return null;
    }
    static compareArticleByDate(article1, article2) {
        if (article1.date === undefined) {
            if (article2.date === undefined) {
                return article1.links[0].title.localeCompare(article2.links[0].title);
            }
            else {
                return -1;
            }
        }
        else {
            if (article2.date === undefined) {
                return 1;
            }
            else {
                const str1 = (article1.date.toString() + "0000").slice(0, 8);
                const str2 = (article2.date.toString() + "0000").slice(0, 8);
                const diff = str1.localeCompare(str2);
                if (diff !== 0) {
                    return diff;
                }
                else {
                    return article1.links[0].title.localeCompare(article2.links[0].title);
                }
            }
        }
    }
}
//# sourceMappingURL=DataLoader.js.map