String jsonExample = '{"source": {"id": null,"name": "Android Central"},"author": "andrew.myrick@futurenet.com (Andrew Myrick)","title": "We need more accessories like the new Backbone One: Xbox Edition","description": "What do you get when you blend 2001 and 2025? The Backbone One: Xbox Edition, and it\'s absolutely beautiful.","url": "https://www.androidcentral.com/gaming/gaming-accessories/we-need-more-accessories-like-the-new-backbone-one-xbox-edition","urlToImage": "https://cdn.mos.cms.futurecdn.net/bsgZyQSVHoSkezdW7RVDoQ-1200-80.jpg","publishedAt": "2025-03-30T09:00:00Z","content": "Let\'s just get this out of the way — there are so many mobile controllers at your disposal that we probably don\'t actually need anymore. Especially if it\'s just a one-off or one with a different colo"}';

// NewsAPIResponse.Article newDemo = new NewsAPIResponse.Article();
// System.debug(newDemo.toSObject(jsonExample));
// System.debug('hello world');
NewsAPIResponse.Article newDemo = new NewsAPIResponse.Article();
// System.debug(newDemo.parse(jsonExample));
// System.debug(newDemo.toSObject(newDemo.parse(jsonExample)));
Article__c parsedArticle = newDemo.toSObject(newDemo.parse(jsonExample));
System.debug(parsedArticle);