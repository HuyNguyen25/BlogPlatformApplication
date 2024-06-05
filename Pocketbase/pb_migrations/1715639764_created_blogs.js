/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const collection = new Collection({
    "id": "xhidiug7aujykid",
    "created": "2024-05-13 22:36:04.537Z",
    "updated": "2024-05-13 22:36:04.537Z",
    "name": "blogs",
    "type": "base",
    "system": false,
    "schema": [
      {
        "system": false,
        "id": "bvliduz0",
        "name": "user_id",
        "type": "text",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "min": null,
          "max": null,
          "pattern": ""
        }
      },
      {
        "system": false,
        "id": "fovzoftg",
        "name": "blog_item",
        "type": "json",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "maxSize": 2000000
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
  const collection = dao.findCollectionByNameOrId("xhidiug7aujykid");

  return dao.deleteCollection(collection);
})
