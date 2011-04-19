// ==========================================================================
// Project:   Clusters.messageController
// Copyright: ©2011 My Company, Inc.
// ==========================================================================
/*globals Clusters */

/** @class

  (Document Your Controller Here)

  @extends SC.ArrayController
*/
Clusters.messageController = SC.ArrayController.create(

SC.CollectionRowDelegate, 
/** @scope Clusters.messageController.prototype */ {

selection: null,
listEnabled: YES,
listView: null,

lastAdded: null,

customRowHeightIndexes: SC.IndexSet.create(0,4), 

contentIndexRowHeight: function(view, content, contentIndex)
{
    var mgroup = content.objectAt(contentIndex);
    var msgs = mgroup.get('messages');
    var lines = msgs.length;
    var height = 12 + lines * 16;
    return height;
},

addMessage: function(name, message) 
{

    if (self.lastAdded == null || self.lastAdded.get('name') != 'Axis')
    {
        self.lastAdded = Clusters.store.createRecord(Clusters.MessageGroup, {"name":name, "timestamp":SC.DateTime.create(), "messages":[message]});
        this.get('customRowHeightIndexes').add(this.content.get('length'));
    }
    else
    {
        self.lastAdded.get('messages').push(message);
        self.lastAdded.recordDidChange();
        Clusters.mainPage.mainPane.middleView.contentView.rowHeightDidChangeForIndexes(this.indexOf(self.lastAdded));
    }
    Clusters.mainPage.mainPane.bottomView.inputView.set('value','');
}


}) ;
