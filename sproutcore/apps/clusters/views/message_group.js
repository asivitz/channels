// ==========================================================================
// Project:   Clusters.MessageGroupView
// Copyright: ©2011 My Company, Inc.
// ==========================================================================
/*globals Clusters */

/** @class

  (Document Your View Here)

  @extends SC.View
*/
Clusters.MessageGroupView = SC.View.extend(SC.ContentDisplay,
/** @scope Clusters.MessageGroupView.prototype */ {

    name: 'Axis',
    timestamp: '4/15/11',
    messages: ['Today I had a good lunch.', 'It was apples and peanuts and marmalade.', 'And a candy bar for dessert.'],

    classNames: ['group-message-view'],
    contentDisplayProperties: 'name timestamp messages'.w(),



    render: function(context, firstTime) {

        var content = this.get('content');
        var name = content.get('name');
        var timestamp = content.get('timestamp');
        var messages = content.get('messages');

        context = context.begin('div').addClass('group-message-view-name').push(name).end();
        context = context.begin('div').addClass('group-message-view-timestamp').push(timestamp.toFormattedString("%a %i:%M %p")).end();
        context = context.begin('div').addClass('group-message-view-messages');
        for (var i = 0; i < messages.length; i++)
        {
            context = context.begin('div').addClass('group-message-view-message').push(messages[i]).end();
        }
        context = context.end();

        sc_super();
        }

});
