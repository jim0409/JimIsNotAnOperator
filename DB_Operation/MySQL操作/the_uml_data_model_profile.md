# intro

The UML Data Model Profile
The Data Model Profile is a UML extension that supports the modeling of relational databases in UML.
資料模型是一個`UML`的延伸，一種關聯式資料庫的`UML`

It includes custom extensions for such things as tables, data base schema, table keys, triggers, and constraints.
他可以客製各種擴展，像是 表、資料格式、表的鍵值、觸發器 以及 定義約束

While this is not a ratified extension, it still illustrates one possible technique for modeling a relational database in the UML.
即便他不是一個被批准的擴充，他仍然可以枚舉各種可能的技術 對於 模組化這個關係資料庫的 透過 UML



# Tables and Columns

A table in the UML Data Profile is a class with the «Table» stereotype, displayed as above with a table icon in the top right corner.
`table(表)`在UML Data Profile中表示為一個`<Table>`的刻板印象，表頭表示為該表的名稱

Database columns are modeled as attributes of the «Table» class.
換句話說`Database`的欄是modeled為屬性之中的`Table`類

e.g.
```
Customer <table>
    |
    v
Customer <table>
PK OID: int
   Name: VARCHAR(2)
   Address: VARCHAR(2)
```
For example, the figure above shows some attributes associated with the Customer table.
以上述為例，這個`Customer`的表格顯示出與其關聯的其他資訊

In the example, an object id has been defined as the primary key, as well as two other columns, Name and Address.
在這個範例中，一個物件的`id`被定義為`primary key`，同時其他兩個欄位名稱為`Name`以及`Address`

Note that the example above defines the column type in terms of the native DBMS data types.
備註: 該欄位名稱的資料型別是原生的`DBMS`資料型別




# Behavior

So far we have only defines the logical (static) structure of the table;
至此，我們已經定義了表的邏輯(靜態)資料結構

In addition we should describe the behavior associated with columns, including indexes, keys, triggers, procedures, and so on.
此外，我們應該描述該表對應的欄位，涵括`indexes`,`keys`,`triggers`,`procedures`...等

Behavior is represented as stereotyped operations.
`Behavior(行為)`可以表示為一種刻板印象的操作

The figure below shows our table above with a primary key constraint and index, both defined as stereotyped operations:
```
Customer
PK OID: int
   Name: VARCHAR(2)
   Address: VARCHAR(2)
---
+   <PK> idx_customer00()
+   <index> idx_customer01()
```
Note that the PK flag on the column 'OID' defines the logical primary key, 
值得注意的是，`PK`這個旗幟表示`OID`這個欄位為`primary key`

while the stereotyped operation “«PK» idx_customer00” defines the constraints
而操作的刻板印性`<PK> idx_customer00`定義了一個`constraints(約束)`

and behavior associated with the primary key implementation (that is, the behavior of the primary key).
且該行為關聯到`primary key`的嵌入，這邊的行為即為一個`primary key`

Adding to our example, 
豐富這個例子

we may now define additional behavior such as triggers, constraints and stored procedures as in the example below:
可以定義一些額外的行為，如`triggers`, `constraints`以及`stored procedures`
```
Customer
PK OID: int
   Name: VARCHAR(2)
   Address: VARCHAR(2)
---
+   <PK> idx_customer00()
+   <FK> idx_customer02()
+   <index> idx_customer01()
+   <Trigger> trg_customer00()
+   <Unique> unq_customer00()
+   <Proc> sp_Update_Customer()
+   <Check> chk_customer00()
```
The example illustrates the following possible behavior:
以上的行爲表達了幾種含義

1. A primary key constraint (PK)

2. A Foreign key constraint (FK)

3. An index constraint (Index)

4. A trigger (Trigger)

5. A uniqueness constraint (Unique)

6. A stored procedure (Proc)

Not formally part of the data profile, but an example of a possible modeling technique Validity check (Check).

Using the notation provided above, it is possible to model complex data

structures and behavior at the DBMS level. In addition to this, the UML

provides the notation to express relationships between logical entities.


# Relationships

The UML data modeling profile defines a relationship as a dependency of any kind between two tables.
UML資料模型定義了一個表之間的關聯相依性

It is represented as a stereotyped association and includes a set of primary and foreign keys.
它表示關聯的刻板印象，其同時涵蓋`primary key`以及`foreign keys`

The data profile goes on to require that a relationship always involves a parent and child, 
`data profile`表示該關聯需要涵蓋的`parenet`以及`child`

the parent defining a primary key and the child implementing a foreign key based on all or part of the parent primary key.
`parent(父母)`定義了`primary key`，而`child(子女)`映射了`foreign key`(表是否張表會基於其所有的`primary key`)

# The relationship is termed 
- 'identifying' 
> if the child foreign key includes all the elements of the parent primary key and
如果子女的`foreign key`涵括所有的元素 of 該父母的`primary key`以及`non-identifying`

- 'non-identifying'
> if only some elements of the primary key are included.
如果只有部分元素 of `the primary key`是被涵括的

The relationship may include cardinality constraints and be modeled with the relevant PK – FK pair named as association roles.
這種關聯，可以涵括`一個可數有限集的` constraints，且其可以被模組化其 關聯性，`PK - FK`即為一組關聯的角色

The illustration below illustrates this kind of relationship modeling using UML.
```
Parent            Child
PK_PersonID <---> FK_PersonID
```


# The Physical Model
UML also provides some mechanisms for representing the overall physical structure of the database, its contents, and deployed location. 
UML同時提供一些機制及表現方法，在實際的資料庫上，其內容及放置位置

To represent a physical database in UML, use a stereotyped component as in the figure below:
```
<Database>
MainOraDB
```

A component represents a discrete and deployable entity within the model.
在模組中`component`表示一個離散，且折疊性的資料結構

In the physical model, a component may be mapped on to a physical piece of hardware (a 'node' in UML).
在這個模組中，一個`component`或許會映射到另一個物理上的記憶體(或者某個機器上的節點)

To represent schema within the database, use the «schema» stereotype on a package.
要表示這個schema上的database可以會用`schema`這個刻板印象的模塊來包裝他

A table may be placed in a «schema» to establish its scope and location within a database.
```
<Schema>
User
- Child
- GrandChild
- GrandParent
- Parent
- Person
```

# Mapping from the Class Model to the Relational <Model>

Having described the two domains of interest and the notation to be used,

we can now turn our attention as to how to map or translate from one domain to the other.

The strategy and sequence presented below is meant to be suggestive rather than proscriptive adapt the steps
and procedures to your personal requirements and environment.



1. Model Classes

Firstly we will assume we are engineering a new relational database schema from a class model we
have created. This is obviously the easiest direction as the models remain
under our control and we can optimize the relational data model to the class
model. In the real world it may be that you need to layer a class model on
top of a legacy data modela more difficult situation and one that presents
its own challenges. For the current discussion will focus on the first situation.
At a minimum, your class model should capture associations, inheritance,
and aggregation between elements.

2. Identify persistent objects

Having built our class model we need to separate it into those elements that require persistence and those that do not. For example, if we have designed our application using the Model-View-Controller design pattern, then only classes in the
model section would require persistent state.

3. Assume each persistent class maps to one relational table

A fairly big assumption, but one that works in most
cases (leaving the inheritance issue aside for the moment). In the simplest
model a class from the logical model maps to a relational table, either in
whole or in part. The logical extension of this is that a single object (or
instance of a class) maps to a single table row.


4. Select an inheritance strategy

Inheritance is perhaps the most problematic relationship and logical construct from
the object-oriented model that requires translating into the relational model.
The relational space is essentially flat, every entity being complete in
itself, while the object model is often quite deep with a well-developed class hierarchy. The deep class model may have many layers of inherited attributes and behavior, resulting in a final, fully featured object at run-time.
There are three basic ways to handle the translation of inheritance to a
relational model:

```
Each class hierarchy has a single corresponding table that contains
all the inherited attributes for all elementsthis table is therefore the
union of every class in the hierarchy. For example, Person, Parent, Child,
and Grandchild may all form a single class hierarchy, and elements from
each will appear in the same relational table;
Each class in the hierarchy has a corresponding table of only the
attributes accessible by that class (including inherited attributes). For
example, if Child is inherited from Person only, then the table will contain
elements of Person and Child only;
Each generation in the class hierarchy has a table containing only
that generation's actual attributes. For example, Child will map to a single
table with Child attributes only.
```
There are cases to be made for each approach, but I would suggest the
simplest, easiest to maintain and less error prone is the third option.
The first option provides the best performance at run-time and the second
is a compromise between the first and last. The first option flattens the
hierarchy and locates all attributes in one tableconvenient for updates
and retrievals of any class in the hierarchy, but difficult to authenticate
and maintain. Business rules associated with a row are hard to implement,
as each row may be instantiated as any object in the hierarchy. The dependencies
between columns can become quite complicated. In addition, an update to any
class in the hierarchy will potentially impact every other class in the hierarchy,
as columns are added, deleted or modified from the table.

The second option is a compromise that provides better encapsulation and
eliminates empty columns. However, a change to a parent class may need to
be replicated in many child tables. Even worse, the parental data in two
or more child classes may be redundantly stored in many tables; if a parent's
attributes are modified, there is considerable effort in locating dependent
children and updating the affected rows.

The third option more accurately reflects the object model, with each
class in the hierarchy mapped to its own independent table. Updates to parents
or children are localized in the correct space. Maintenance is also relatively
easier, as any modification of an entity is restricted to a single relational
table also. The down side is the need to re-construct the hierarchy at run-time
to accurately re-create a child class's state. A Child object may require
a Person member variable to represent their model parentage. As both require
loading, two database calls are required to initialize one object. As the
hierarchy deepens, with more generations, the number of database calls required
to initialize or update a single object increases.

It is important to understand the issues that arise when you map inheritance
onto a relational model, so you can decide which solution is right for you.



5. For each class add a unique object identifier

In both the relational and the object world, there is the need to uniquely
identify an object or entity. In the object model, non-persistent objects
at run-time are typically identified by direct reference or by a pointer
to the object. Once an object is created, we can refer to it by its run-time
identity. However, if we write out an object to storage, the problem is how
to retrieve the exact same instance on demand. The most convenient method
is to define an OID (object identifier) that is guaranteed to be unique in
the namespace of interest. This may be at the class, package or system level,
depending on actual requirements.
An example of a system level OID might be a GUID (globally unique identifier)
created with Microsoft's 'guidgen' tool; for example, {A1A68E8E-CD92-420b-BDA7-118F847B71EB}.
A class level OID might be implemented using a simple numeric (for example, 32-bit
counter). If an object holds references to other objects, it may do so using
their OID. A complete run-time scenario can then be loaded from storage reasonably
efficiently. An important point about the OID values above is that they
have no inherent meaning beyond simple identity. They are only logical pointers
and nothing more. In the relational model, the situation is often quite
different.

Identity in the relational model is normally implemented with a primary
key. A primary key is a set of columns in a table that together uniquely
identify a row. For example, name and address may uniquely identify a 'Customer'.
Where other entities, such as a 'Salesperson', reference the 'Customer',
they implement a foreign key based on the 'Customer' primary key. The problem
with this approach for our purposes is the impact of having business information
(such as customer name and address) embedded in the identifier. Imagine three
or four tables all have foreign keys based on the customer primary key,
and a system change requires the customer primary key to change (for example
to include 'customer type'). The work required to modify both the 'customer'
table and the entities related by foreign key is quite large.

On the other hand, if an OID was implemented as the primary key and formed
the foreign key for other tables, the scope of the change is limited to the
primary table and the impact of the change is therefore much less. Also,
in practice, a primary key based on business data may be subject to change.
For example a customer may change address or name. In this case the changes
must be propagated correctly to all other related entities, not to mention
the difficulty of changing information that is part of the primary key.

An OID always refers to the same entityno matter what other information
changes. In the above example, a customer may change name or address and
the related tables require no change. When mapping object models into relational
tables, it is often more convenient to implement absolute identity using
OID's rather than business related primary keys. The OID as primary and foreign
key approach will usually give better load and update times for objects and
minimize maintenance effort. In practice, a business related primary key
might be replaced with:


- A uniqueness constraint or index on the columns concerned
- Business rules embedded in the class behavior
- A combination of 1 and 2.

Again, the decision to use meaningful keys or OID's will depend on the
exact requirements of the system being developed.


6. Map attributes to columns

In general we will map the simple data attributes of a class to columns
in the relational table. For example a text and number field may represent
a person's name and age respectively. This sort of direct mapping should
pose no problemsimply select the appropriate data type in the vendor's
relational model to host your class attribute.
For complex attributes (in other words, attributes that are other objects) use the
approach detailed below for handling associations and aggregation.

7. Map associations to foreign keys

More complex class attributes (in other words, those which represent other classes),
are usually modeled as associations. An association is a structural relationship
between objects. For example, a Person may live at an Address. While this
could be modeled as a Person has City, Street and Zip attributes, in both
the object and the relational world we are inclined to structure this information
as a separate entity, an Address. In the object domain an address represents
a unique physical object, possibly with a unique OID. In the relational,
an address may be a row in an Address table, with other entities having a
foreign key to the Address primary key.
In both models then, there is the tendency to move the address information
into a separate entity. This helps to avoid redundant data and improves maintainability.
So for each association in the class model, consider creating a foreign
key from the child to the parent table.
```
Salesperson                                                             Customer
PK OID: int                                                             PK OID: int
   Name: VARCHAR(2)         PK_Salesperson               FK_Salesperson    Name: VARCHAR(2)
   Department: VARCHAR(2)   <------------------------------------------>   Address: VARCHAR(2)
---                                                                        Salesperson: int
+   <PK> PK_Salesperson()                                                  ---
                                                                           +   <PK> PK_Customer()
                                                                           +   <FK> PK_Salesperson()
```

8. Map Aggregation and Composition

Aggregation and composition relationships are similar to the association
relationship and map to tables related by primary-foreign key pairs. There
are however, some points to bear in mind. Ordinary aggregation (the weak
form) models relationships such as a Person resides at one or more Addresses.
In this instance, more than one person could live at the same address, and
if the Person ceased to exist, the Addresses associated with them would still
exist. This example parallels the many-to-many relationship in relational
terminology, and is usually implemented as a separate table containing a
mapping of primary keys from one table to the primary keys of another.
A second example of the weak form of aggregation is where an entity has
use or exclusive ownership of another. For example, a Person entity aggregates
a set of shares. This implies a Person may be associated with zero or more
shares from a Share table, but each Share may be associated with zero or
one Person. If the Person ceases to exist, the Shares become un-owned or are
passed to another Person. In the relational world, this could be implemented
as each Share having an 'owner' column which stored a Person ID (or OID).

The strong form of aggregation, however, has important integrity constraints
associated with it. Composition, implies that an entity is composed of parts,
and those parts have a dependent relationship to the whole. For example,
a Person may have identifying documents such as a Passport, Birth Certificate,
Driver's License, and so on. A Person entity may be composed of the set of
such identifying documents. If the Person is deleted from the system, then
the identifying documents must be deleted also, as they are mapped to a unique
individual.

If we ignore the OID issue for the moment, a weak aggregation could be
implemented using either an intermediate table (for the many-to-many case)
or with a foreign key in the aggregated class/table (one-to-many case). In
the case of the many-to-many relationship, if the parent is deleted, the entries
in the intermediate table for that entity must also be deleted also. In the
case of the one-to-many relationship, if the parent is deleted, the foreign
key entry (in other words, 'owner') must be cleared.

In the case of composition, the use of a foreign key is mandatory, with
the added constraint that on deletion of the parent the part must be deleted
also. Logically there is also the implication with composition that the primary
key of the part forms part of the primary key of the wholefor example,
a Person's primary key may composed of their identifying documents ID's.
In practice this would be cumbersome, but the logical relationship holds
true.

9. Define relationship roles

For each association type relationship, each end of the relationship may
be further specified with role information. Typically, you will include the
Primary Key constraint name and the Foreign Key Constraint name. Figure 6
illustrates this concept. This logically defines the relationship between
the two classes. In addition, you may specify additional constraints (for example,
{Not NULL}) on the role and cardinality constraints (for example, 0…n).

10. Model behavior

We now come to another difficult issue: whether to map some or all class
behavior to the functional capabilities provided by database vendors in
the form of triggers, stored procedures, uniqueness and data constraints,
and relational integrity. A non-persistent object model would typically implement
all the behavior required in one or more programming languages (for example, Java
or C++). Each class will be given its required behavior and responsibilities
in the form of public, protected and private methods.
Relational databases from different vendors typically include some form
of programmable SQL based scripting language to implement data manipulation.
The two common examples are triggers and stored procedures. When we mix the
object and relational models, the decision is usually whether to implement
all the business logic in the class model, or to move some to the often more
efficient triggers and stored procedures implemented in the relational DBMS.
From a purely object-oriented point of view, the answer is obviously to
avoid triggers and stored procedures and place all behavior in the classes.
This localizes behavior, provides for a cleaner design, simplifies maintenance
and provides good portability between DBMS vendors.

In the real world, the bottom line may be scaling to 100's or 1000's of
transactions per second, something stored procedures and triggers are purpose
designed for. If purity of design, portability, maintenance and flexibility
are the main drivers, localize all behavior in the object methods.

If performance is an over-riding concern, consider delegating some behavior
to the more efficient DBMS scripting languages. Be aware though that the
extra time taken to integrate the object model with the stored procedures
in a safe way, including issues with remote effects and debugging, may cost
more in development time than simply deploying to more capable hardware.

As mentioned earlier, the UML Data Profile provides the following extensions
(stereotyped operations) with which you can model DBMS behavior:
```
Primary key constraint (PK)
Foreign key constraint (FK)
Index constraint (Index)
Trigger (Trigger)
Uniqueness constraint (Unique)
Validity check (Check).
```

11. Produce a physical model

In UML, the physical model describes how something will be deployed into
the real worldthe hardware platform, network connectivity, software, operating
system, dll's and other components. You produce a physical model to complete
the cyclefrom an initial use case or domain model, through the class
model and data models and finally the deployment model. Typically for this
model you will create one or more nodes that will host the database(s) and
place DBMS software components on them. If the database is split over more
than one DBMS instance, you can assign packages («schema») of tables to
a single DBMS component to indicate where the data will reside.



Conclusion
This concludes this short article on database modeling using the UML.
As you can see, there are quite a few issues to consider when mapping from
the object world to the relational. The UML provides support for bridging
the gap between both domains, and together with extensions such as the UML
Data Profile is a good language for successfully integrating both worlds.

