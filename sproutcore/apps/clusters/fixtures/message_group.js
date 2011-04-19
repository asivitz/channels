// ==========================================================================
// Project:   Clusters.MessageGroup Fixtures
// Copyright: ©2011 My Company, Inc.
// ==========================================================================
/*globals Clusters */

sc_require('models/message_group');

Clusters.MessageGroup.FIXTURES = [

   { guid: 1,
     name: "Axis",
     timestamp: SC.DateTime.create({year:2011, month:4, day:18, hour:12}),
     messages: ['Today I had a good lunch.', 'It was apples and peanuts and marmalade.', 'And a candy bar for dessert.']
     },
  
   { guid: 2,
     name: "Micah",
     timestamp: SC.DateTime.create({year:2011, month:4, day:18, hour:13}),
     messages: ['Oh really that is neat.', 'I like apples.']
     },

   { guid: 3,
     name: "Lumen",
     timestamp: SC.DateTime.create({year:2011, month:4, day:18, hour:14}),
     messages: ['That is certainly not neat.', 'Apples are gross.']
     },

   { guid: 4,
     name: "Axis",
     timestamp: SC.DateTime.create({year:2011, month:4, day:18, hour:15}),
     messages: ['No way.', 'Lol.', 'You are wrong.']
     },
];
