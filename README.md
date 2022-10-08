# my_nosql_db
 My NoSql DB

## Prerequisites
- ruby 2.6.3 (`rbenv install 2.6.3`)

Make sure its pointed to 2.6.3 or we need to set by doing
```bash
$ rbenv local 2.6.3
```

This command sets a local application-specific Ruby version by writing the version name to a `.ruby-version` file in the current directory. You can check the ruby version in your current directory by doing
```bash
$ ruby -v
```

## Setting up the application
unzip the file
```bash
$ unzip my_nosql_db.zip
```

Go to the project directory
```bash
$ cd my_nosql_db
```

## Getting Started

start irb
```bash
$ irb
```

require or load the init.rb file
```bash
> require_relative 'app/init'
```

instantiate the db
```bash
> db
```

you'll receive a database object, which can now be used to work on
```bash
Welcome to my NoSql DB!
 Use `help` to view the list of available commands
 => #<Database:0x00007fbc3888f350>
```

To view the list of commands use `help`
```bash
> db.help
List of commands::
  Commands on Collections:
        Create a new Collection          :create_collection(collection)
        List all Collections             :list_collections
        Drop a Collection                :drop_collection(collection)
  Commands on Records:
        List all Records                 :all
        Find a Record by Key-Value       :find_by(key, value)
        Find all Records by Key-Value    :where(key, value)
        Find a Field Value in a Record   :find(id).select(key) || :find_by(key, value).select(key)
        Find a Record by id              :find(id)
        Add a Record                     :insert(record)
        Delete a Record                  :find(id).destroy || :find_by(key, value).destroy
        Delete a Record by Key-Value     :destroy_records(key, value)
```

### Commands

To create a new Collection, use
```bash
> db.create_collection(<collection_name>)
```
so, to create a Colelction `loans`
```bash
> db.create_collection('loans')
Collection `loans` is created successfully!
```

To List all existing Collections
```bash
> db.list_collections
=> ["loans", "products"]
```

To drop an existing Collection `loans`
```bash
> db.drop_collection("loans")
Collection `loans` is dropped successfully!
```

To perform operations on a Collection,
```bash
> db.<collection_name>
```
so to perform operations on `loans` collection,
```bash
> db.loans
=> #<Collection:0x00007fcd33890d48 @collection=:loans>
```

To add a record/document into a collection `loans`
```bash
> db.loans.insert({"sector": "personal", "amount": 5113, "tenure": 1})
Record is created successfully!
=> #<Record:0x00007fc5ca867aa8 @data={"_id"=>"2603fbcd-1303-4b1a-be54-fb96589062d8", :sector=>"personal", :amount=>5113, :tenure=>1}, @collection=:loans>
```

To list all records/documents in a collection `loans`
```bash
> db.loans.all
=> [#<Record:0x00007fb8bc092d98 @data={"_id"=>"9388db31-51fa-48c7-aba6-6d6426023de5", "sector"=>"sme_secure", "amount"=>4481, "tenure"=>7}, @collection=:loans>, #<Record:0x00007fb8bc092910 @data={"_id"=>"a7055867-7de8-4f10-9bc6-a7fd4f7a1615", "sector"=>"personal", "amount"=>734, "tenure"=>2}, @collection=:loans>, #<Record:0x00007fb8bc092690 @data={"_id"=>"469b7dc1-4adf-4f3e-bb07-edd8f5e76413", "sector"=>"sme_unsecured", "amount"=>430, "tenure"=>7}, @collection=:loans>, #<Record:0x00007fb8bc092280 @data={"_id"=>"868e73d0-3098-4039-9dee-bc08833d2a72", "sector"=>"consumer", "amount"=>8538, "tenure"=>4}, @collection=:loans>, #<Record:0x00007fb8bc091e98 @data={"_id"=>"42abe158-70f0-4ae0-91e6-6f3b7a31683d", "sector"=>"personal", "amount"=>1411, "tenure"=>8}, @collection=:loans>]
```

To find a record/document by id from a collection `loans`
```bash
> db.loans.find("868e73d0-3098-4039-9dee-bc08833d2a72")
=> #<Record:0x00007fc5ca88b9f8 @data={"_id"=>"868e73d0-3098-4039-9dee-bc08833d2a72", "sector"=>"consumer", "amount"=>8538, "tenure"=>4}, @collection=:loans>
```

To find a record/document by a key, value pair from a collection `loans`
```bash
> db.loans.find_by("sector", "personal")
=> #<Record:0x00007fc5c9883498 @data={"_id"=>"a7055867-7de8-4f10-9bc6-a7fd4f7a1615", "sector"=>"personal", "amount"=>734, "tenure"=>2}, @collection=:loans>
```

To find all records/documents by a key, value pair from a collection `loans`
```bash
> db.loans.where("sector", "sme")
=>  [#<Record:0x00007fc5c70d9618 @data={"_id"=>"e65d085e-eeab-4a7e-8e56-da0868585dea", "sector"=>"sme", "amount"=>1619, "tenure"=>1}, @collection=:loans>, #<Record:0x00007fc5c70d82b8 @data={"_id"=>"b01204a6-e534-4afd-98cd-b1f9b3c632ac", "sector"=>"sme", "amount"=>5215, "tenure"=>6}, @collection=:loans>, #<Record:0x00007fc5ca882df8 @data={"_id"=>"0b4f35d1-666d-4b98-a1a9-603b47ad4218", "sector"=>"sme", "amount"=>653, "tenure"=>3}, @collection=:loans>, #<Record:0x00007fc5ca882358 @data={"_id"=>"fdb3506d-fa63-4595-8a28-374e54eb8029", "sector"=>"sme", "amount"=>8760, "tenure"=>7}, @collection=:loans>, #<Record:0x00007fc5ca881e30 @data={"_id"=>"c756af67-3754-4729-b9bb-598eedad9ea9", "sector"=>"sme", "amount"=>2982, "tenure"=>7}, @collection=:loans>, #<Record:0x00007fc5ca881750 @data={"_id"=>"7eb69294-b7a8-4420-8b5d-df4a3899bdde", "sector"=>"sme", "amount"=>3443, "tenure"=>4}, @collection=:loans>]
```

To select a particular field `amount` of a record in a collection `loans`
```bash
> db.loans.find_by("sector", "personal").select("amount")
=> 734
```
or
```bash
> db.loans.find("cd1ffb44-622e-48ca-98d1-1d8ed44169d7").select("sector")
=> "consumer"
```

To delete a record/document by id from a collection `loans`
```bash
> db.loans.find_by("amount", 430).destroy
Record is deleted successfully!
```

To delete all records/documents by a key, value pair from a collection `loans`
```bash
> db.loans.destroy_records("sector", "lap")
8 Records are deleted successfully!
```

Insert some random documents into the collection `loans` to perform some query operations
```bash
100.times do 
  db.loans.insert({"sector": %w[consumer two_wheeler sme sme_secure sme_unsecured lap education personal].sample, "amount": rand(10000), "tenure": rand(10)})
end
```
