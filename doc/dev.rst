
Objective: a metadata (layout/views/fields?) driven web-app for outliner-document types.


Goals

1. menu, card and object views
2. edit views, folder organization, metadata/outliner document management
3. extensible types


Design

- Similar library and dependency handling to node-sitefile.
- All unoptimized, no build. Suited for development mode.

/main
  a require.js client.
  TODO: load container for field-datum


Progress

- Basic Node.JS/Express project setup done.
- Some make and grunt for project/build tooling.
- Going with service-container for managing types and type extensions
