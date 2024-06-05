/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("dhwws8uga61gv9a")

  // remove
  collection.schema.removeField("gqirc0qb")

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("dhwws8uga61gv9a")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "gqirc0qb",
    "name": "userAvatar",
    "type": "text",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "min": null,
      "max": null,
      "pattern": ""
    }
  }))

  return dao.saveCollection(collection)
})
