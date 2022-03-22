# intro
### 什麼是 VPC
1. `virtual private cloud`的縮寫，也代表該AWS帳號的虛擬網路
2. 他是AWS特有的名詞，有別於其他cloud
3. 這邊的`VPC`與傳統的`VLAN`概念相同
4. 可以透過預設，將AWS上的ec2運行在指定的VPC下


### 什麼是 Subnet
1. `subnet`代表一組子IP的範圍，可以被加入到某個`VPC`下面
2. 可以運行一些`AWS`的服務於指定的`subnet`
3. `subnet`又可以分別定義為`public`以及`private`來表示網路是否可以被外界聯繫


### 什麼是 Routing Table
1. `Route table`等同於`iptables`，具備一系列的規則，用來決定網路流向
2. 每一個`VPC`下的`subnet`都必須關聯一組`route table`;(該組table會控制這個子網內的所有路由)
3. 一個`subnet`一次只能被關聯一組`route table`，但是`route table`可以被複數個`subnet`所使用


### 什麼是 Internet Gateway (IGW)
1. `IGW`是一個可以水平擴展，並且可以綁定一個`VPC`，VPCs彼此之間的交流需要透過`connect peer`服務
2. 通常會實現一個`IGW`其目的旨在
	1. 提供一個`target`給VPC路由，讓其可以與外部網路通連
	2. 架構`NAT`環境，確保只有部分服務是可以通向外網的


```UML
							Region
i-------------------  VPC (10.0.0.0/16)  -------------------i
i															i
i	Availability Zone A										i
i	||======================================||				i
i	||10.0.0.5 --|						    ||				i
i	||10.0.0.6 --|-- EC2 Instances		    ||----------|	i
i	||10.0.0.7 --|  (subnet 1: 10.0.0.0/24) ||		  	|	i		`Main Route Table`
i	||======================================||			|	i	||======================||
i														|	i 	|| Destination | Target ||
i													Router------||=============|========||
i	Availability Zone B									|	i 	|| 10.0.0.0/16 | local  ||
i	||======================================||			|	i 	||=============|========||
i	||10.0.1.5 --|						    ||			|	i
i	||10.0.1.6 --|-- EC2 Instances		    ||----------|	i
i	||10.0.1.7 --|  (subnet 2: 10.1.0.0/24) ||				i
i	||======================================||				i
i															i
i-----------------------------------------------------------i


VPC.1 ---|
		 |--- `Peer Connection`
VPC.2 ---|

```




# refer:
IT邦幫忙
- https://ithelp.ithome.com.tw/articles/10208680

youtube live operation demo
- https://www.youtube.com/watch?v=CP7yd7nOb5Q