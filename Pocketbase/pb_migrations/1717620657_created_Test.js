/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const collection = new Collection({
    "id": "0cf08rmsxdq99bv",
    "created": "2024-06-05 20:50:57.080Z",
    "updated": "2024-06-05 20:50:57.080Z",
    "name": "Test",
    "type": "base",
    "system": false,
    "schema": [
      {
        "system": false,
        "id": "w14jeqen",
        "name": "title",
        "type": "text",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "min": null,
          "max": null,
          "pattern": ""
        }
      }
    ],
    "indexes": [],
    "listRule": null,
    "viewRule": null,
    "createRule": null,
    "updateRule": null,
    "deleteRule": null,
    "options": {}
  });

  return Dao(db).saveCollection(collection);
}, (db) => {
  const dao = new Dao(db);
  const collection = dao.findCollectionByNameOrId("0cf08rmsxdq99bv");

  return dao.deleteCollection(collection);
})
