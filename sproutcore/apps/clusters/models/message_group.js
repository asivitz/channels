// ==========================================================================
// Project:   Clusters.MessageGroup
// Copyright: ©2011 My Company, Inc.
// ==========================================================================
/*globals Clusters */

/** @class

  (Document your Model here)

  @extends SC.Record
  @version 0.1
*/
Clusters.MessageGroup = SC.Record.extend(
/** @scope Clusters.MessageGroup.prototype */ {

name: SC.Record.attr(String),
timestamp: SC.Record.attr(SC.DateTime),
messages: SC.Record.attr(Array)

}) ;
