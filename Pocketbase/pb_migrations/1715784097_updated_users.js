/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("p19thz3aoicut7z")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "eysewbau",
    "name": "field",
    "type": "relation",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "collectionId": "xhidiug7aujykid",
      "cascadeDelete": false,
      "minSelect": null,
      "maxSelect": 1,
      "displayFields": null
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("p19thz3aoicut7z")

  // remove
  collection.schema.removeField("eysewbau")

  return dao.saveCollection(collection)
})
