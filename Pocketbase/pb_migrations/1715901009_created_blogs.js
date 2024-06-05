/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const collection = new Collection({
    "id": "dhwws8uga61gv9a",
    "created": "2024-05-16 23:10:09.023Z",
    "updated": "2024-05-16 23:10:09.023Z",
    "name": "blogs",
    "type": "base",
    "system": false,
    "schema": [
      {
        "system": false,
        "id": "ruslxdhm",
        "name": "field",
        "type": "select",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "maxSelect": 1,
          "values": [
            "UI/UX",
            "Data Science",
            "AI",
            "Mobile Development",
            "DevOps",
            "Web Development",
            "Cybersecurity",
            "IoT",
            "Others"
          ]
        }
      },
      {
        "system": false,
        "id": "u7g2q4mu",
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
      },
      {
        "system": false,
        "id": "5zbezcqb",
        "name": "content",
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
        "id": "6r9qz895",
        "name": "likes",
        "type": "number",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "min": null,
          "max": null,
          "noDecimal": false
        }
      },
      {
        "system": false,
        "id": "9am16vhs",
        "name": "user_id",
        "type": "relation",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "collectionId": "p19thz3aoicut7z",
          "cascadeDelete": false,
          "minSelect": null,
          "maxSelect": 1,
          "displayFields": null
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
  const collection = dao.findCollectionByNameOrId("dhwws8uga61gv9a");

  return dao.deleteCollection(collection);
})
