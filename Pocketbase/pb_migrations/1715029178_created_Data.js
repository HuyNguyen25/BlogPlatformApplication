/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const collection = new Collection({
    "id": "vo0g9egqrotfeuy",
    "created": "2024-05-06 20:59:38.879Z",
    "updated": "2024-05-06 20:59:38.879Z",
    "name": "Data",
    "type": "base",
    "system": false,
    "schema": [
      {
        "system": false,
        "id": "xgtx7tci",
        "name": "name",
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
  const collection = dao.findCollectionByNameOrId("vo0g9egqrotfeuy");

  return dao.deleteCollection(collection);
})
