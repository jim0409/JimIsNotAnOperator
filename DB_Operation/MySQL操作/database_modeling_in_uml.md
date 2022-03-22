# intro
當整個軟體系統需要一個持久化資料時，設計者/架構師 通常會思考於

"物件導向式"、"物件關聯"或"混合關聯"等方式來設計我們的資料庫關聯表單

這邊將紀錄一個階層式的"物件導向"式的資料結構

# steps
1. 首先從領域的角度來看，以物件導向模型來推估UML
2. 其次考慮關聯資料庫的特性

## 領域角度評估物件導向UML
從領域上來看，考慮每一個環節上物件可能會涵括的資料屬性(具備哪些關鍵屬性)

考量屬性之間的耦合度，該屬性是否會映射到另一個屬性

從而也考慮哪些物件的資料是應該被持久化，行為物件?關聯物件或者物件本身

*通常一個良好的物件導向式UML攸關一向纏品設計邏輯性上的好壞，同時結合了資料提供者的需求，也列舉了各項模塊影響的範圍

### Class Model(在此假定模塊為well-defined)
`抽象類`(涵括`資料`及`行為`)是評估整個UML模型是否設計良好的關鍵

一個抽象類，可以比喻為一個`模塊`或一個`範本`

當我們在喀發一個邏輯的模型時，我們會暴露出要使用的`抽象類`

尤其當我們在處理動態的程序時，例如`時間`數據以及`交互`數據，我們多半都會解耦於`抽象類`下產出的`物件的實例`

封裝該`抽象類`的準則基於其`內部控制及影響的資料流(物件)`以及`影響到該抽象類內部資料流(物件)所需要負責的行為`
<!-- (he principal of data hiding or encapsulation is based on localization of effect. A class has internal data elements that it is responsible for. Access to these data elements) -->

此外，`抽象類`應該具備可以繼承性以保持後續代碼的可讀性、可維護性

```UML(TODO: make it as .puml)
Person(A simple person class with no state or behavior shown)
Person Class(-Address: CAddress #Name:string/#Age:double| method: getAge(): int/ setAger(n)/ getName(): string/ setName(s))

Class attributedsL the encapsulated data
Class Operations; the behavior
Adherence Person ... 
```

- Behavior(行為類)
1. 行為被封裝在`抽象類`內部，用來表示如何操作及定義該抽象類
2. 行為可以為`公開的(public)`或者`私有的(private)`，通過`公開的`行為讓外部可以訪問到`抽象類`內部的公、私物件
<!-- Operations may be externally visible (public), visible to children (protected), or hidden (private). -->
3. 透過結合`私有物件`及`公開行為`，可以讓這個`抽象類`可以在保證資料保護性下更加可讀


- Relationships and Identity(物件之間的關聯)
當抽象類之間存在至少一種(含以上)的關係時，
```UML(TODO: make it as .puml)
Person -> Family (Aggregation captures captures the concept collections or composition between classes)
Parent -> Person (A class hierachly showing a generallized person class from which other classes are dervied)
Parent <-> Child (Association on captures a having or using relationship between classes)
Child -> Person (The main relationships we are interested in are Asssociation, Aggregation and Inheritance)
```

`關聯(Association)`表示抽象類之間的關係，只要兩類別之間有一個`方法`或者`資料結構體`可以影響對方，則代表兩抽象具備關聯
Aggregation is a form of association that implies the collection of one class of objects within another. 

聚合是一個形式，它表示眾多的collection中的類屬於另一個

Composition is a stronger form of aggregation that implies one object is actually composed of others. 

組合是一個比較強型態的聚合，它表示底下的任何一個物件都是由其他物件所合成的

Like the association relationship, this implies a complex class attribute that requires careful consideration in the process of mapping to the relational domain. 

同其他關聯，這表示一個複雜的類需要謹慎的考慮，在程序執行中對應到各個關聯領域

While a class represents the template or model from which many object instances may be created, 

當一個類表示 一個範本 或 一個模型 (通常都會由其他物件實例所組成)

an object at run-time requires some means of identifying itself such that associated objects may act upon the correct object instance. 

一個物件在運行時，通常會識別他自己以此來與其他物件交流

In a programming language like C++, object pointers may be passed around and held to allow objects access to a unique
object instance. 

對特別語言，諸如C++，具備物件指標(唯一性)，或許會將指標傳遞給其他物件

Often though, an object will be destroyed and require that it be re-created as it was during its last active instance. 

通過如此，一個物件會以他被產生的方式做終止

These objects require a storage mechanism to save their internal state and associations into and to retrieve that state as required.

這些物件需要一個儲存機制，去保證他們內部的狀態及其對應的關聯性，及獲得他們狀態的對應方法


Inheritance provides the class model with a means of factoring out common behavior into generalized classes that then act as the ancestors of many variations on a common theme. 

繼承提供一個類型模組，組織行為模式為通常類別。並且作為下面子類別的祖父件

Inheritance is a means of managing both re-use and complexity. 
繼承通常代表管理、複用以及複合

As we will see, the relational model has no direct counterpart of inheritance, 
如同我們所見，關聯式資料模型會直接影響對應的繼承物件

which creates a dilemma for the data modeler mapping an object model onto a relational framework. 
這會造成在模組化這些 關聯模型框架時 的困難

Navigation from one object at run time to another is based on absolute references.
導覽其中一個物件往往是另一個物件的絕對值參照

One object has some form of link (a pointer or unique object ID) with which to locate or re-create the required object.
物件會具有某個連結(或者指標，使用者ID)這些訊息會與 物件的地址 復建 甚至 要求 有關

`聚合(Aggregation)`表示關聯的一種格式，他隱含著某抽象類於另一抽象類下的`collection`


The Relational Model
The relational data model has been around for many years and has a proven track record of providing performance and flexibility.
關聯式資料庫已經運行多年，且有她足夠的證明說明他的效能以及可用性

It is essentially set-based and has as its fundamental unit the 'table', which is composed of a set of one or more 'columns', each of which contains a data element.
勢必要其基於集合以及具有指定功能的列表，列表由對應的`欄位`組成，其中每一項欄位都會涵蓋各自的資料




Tables and Columns
表與欄 的關係

A relational table is a collection of one or more columns, each of which has a unique name within the table construct.
一個關聯資料表通常是一個或多個欄位的集合
Each column is defined to be of a certain basic data type, such as a number, text, or binary data.
每一個欄位都會被定義一項基礎資料型別(number, text, binary data)
A table definition is a template from which table rows are created, each row being an instance of a possible table instance.
一個`template`表的定義為 當一筆紀錄被創造時，每一個紀錄即為一個 實例 或者 可能的實例
The relational model only offers a public data access model.
關聯模型提供一個公開的操作模組
All data is equally exposed and open to any process to update, query, or manipulate it. Information hiding is unknown.
所有的資料均會暴露，以及提供 更新 查詢 操作。沒有任何一筆隱藏資料



Behavior

The behavior associated with a table is usually based on the business or logical rules applied to that entity.
關於表的`行為關係`通常取決於業務邏輯

Constraints may be applied to columns in the form of uniqueness requirements, relational integrity constraints to other tables/rows, allowable values, and data types.
欄位的限制，可能為該欄位的獨特性，關係直接明確於其他表/欄，允許值及資料格式

Triggers provide some additional behavior that can be associated with an entity.
觸發器提供額外的行為，關聯於其他單位

Typically this is used to enforce data integrity before or after updates, inserts, and deletes.
基本上，這是用來強化資料的整合性(每當資料有 更新，新增或刪除)

Database stored procedures provide a means of extending database functionality through proprietary language extensions used to construct functional units (scripts).
資料庫儲存過程提供了一種手段，通過專有語言擴展數據功能。並用構造功能單元

These functional procedures do not map directly to entities, nor have a logical relationship to them.
這些功能既不直接操作這些構造單元，也不會有邏輯上的耦合

Navigation through relational data sets is based on row traversal and table joins.
關係數據集的導航基於 行遍歷 和 表關聯

SQL is the primary language used to select rows and locate instances from a table set.
SQL是其中最主要的語言，去時間行選曲及表設定



Relationships and Identity
關係和身份


The primary key of a table provides the unique identifying value for a particular row.
資料庫的`primary key`提供一個唯一身份識別，同時也是一個比較特殊的身份

There are two kinds of primary keys that we are interested in:
這邊有兩項比較特別的`primary keys`需要注意

- firstly
the meaningful key, made up of data columns which have a meaning within the business domain,
第一，通常`primary key`會具有特定的商業意涵

- second
the abstract unique identifier, such as a counter value, which have no business meaning but uniquely identify a row.
其次，通常他會表示一個識別代號，諸如計數器，可能其不具備商業意義但其為一個具有含義的列




A table may contain columns that map to the primary key of another table.
通常一個表的某一個欄位，會涵括/映射至另一個表的`primary key`

This relationship between tables defines a foreign key and implies a structural relationship or association between the two tables.
關聯資料表定義了一個 外鍵，其涵意表示一個結構體的關聯與另一個表




Summary


From the above overview we can see that the object model is based on discrete entities having both state (attributes/data) and behavior, with access to the encapsulated data generally through the class public interface only.
基於以上，我們可以看到物件模型 具備幾件事 屬性/資料內容 以及 行為(具備一個用戶端的介面封裝)

The relational model exposes all data equally, with limited support for associating behavior with data elements through triggers, indexes, and constraints.
關聯資料庫暴露資料平等的， 在有限的支持及關聯行為下，保證一些資料會被觸發 透過 觸發器/indexes以及constraints

You navigate to distinct information in the object model by moving from object to object using unique object identifiers and established object relationships (similar to a network data model).
透過使用這些唯一的 識別模型物件，建立 物件 到 物件之間的關聯，你將會導引到其他模型

In the relational model you find rows by joining and filtering result sets using SQL using generalized search criteria.
在關聯資料庫魔情中，透過`SQL`語句 你可以 透過`join(關聯)`以及`filter(篩選)` 找到指定的 列資料

Identity in the object model is either a run-time reference or persistent unique ID (termed an OID).
`Identity(識別物)`在物件關係模型中是一個`run-time(即時)`且參照到另一個持久化ID的

In the relational world, primary keys define the uniqueness of a data set in the overall data space.
在互聯的情境下，`primary keys`定義了這個資料表格下的唯一性

In the object model we have a rich set of relationships: inheritance, aggregation, association, composition, dependency, and others.
在`object model(模型即為物件)`下，`relationships(關聯性)`:涵括 `inheritance`, `aggregation`, `association`, `composition`, `dependency`...等

In the relational model we can really only specify a relationship using foreign keys.
在`releational model(關聯模型)`中，可以透過`foreign keys(外鍵)`去指定某一個關係

Having looked at the two domains of interest and compared some of the important features of each, we will digress briefly to look at the notation proposed to represent relational data models in the UML.
當對於某兩個領域之間的事物感到興趣時，會將兩個領域內的特徵值予以比對，透過解析兩者之間的關係領域，在以UML設計出對應於該領域下的資料模型







## 考量關聯式資料庫




# refer:
- https://www.eetimes.com/database-modeling-in-uml/