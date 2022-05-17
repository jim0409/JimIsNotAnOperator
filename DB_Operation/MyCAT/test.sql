-- 分別在每個 master db 上創建 test_db
-- CREATE DATABASE IF NOT EXISTS test_db;

-- 連接 mycat 成功, 在 test_db 下插入 tabl 及賦值
CREATE TABLE IF NOT EXISTS test_db.t_test (
  id BIGINT(20) NOT NULL,
  title VARCHAR(100) NOT NULL ,
  PRIMARY KEY (id)
) ENGINE=INNODB DEFAULT CHARSET=utf8 ;


INSERT INTO test_db.t_test (id,title) VALUES ('1','test0001');
INSERT INTO test_db.t_test (id,title) VALUES ('2','test0002');
INSERT INTO test_db.t_test (id,title) VALUES ('3','test0003');
INSERT INTO test_db.t_test (id,title) VALUES ('4','test0004');
INSERT INTO test_db.t_test (id,title) VALUES ('5','test0005');
INSERT INTO test_db.t_test (id,title) VALUES ('6','test0006');
SELECT * FROM test_db.t_test;


CREATE TABLE IF NOT EXISTS test_db.t_task_test (
  id BIGINT(20) NOT NULL,
  org_code VARCHAR(100) NOT NULL ,
  title VARCHAR(100) NOT NULL ,
  PRIMARY KEY (id)
) ENGINE=INNODB DEFAULT CHARSET=utf8 ;

INSERT INTO test_db.t_task_test (id,org_code,title) VALUES ('1','W12340001','test0001');
INSERT INTO test_db.t_task_test (id,org_code,title) VALUES ('2','W12340002','test0002');
INSERT INTO test_db.t_task_test (id,org_code,title) VALUES ('3','W12340003','test0003');
INSERT INTO test_db.t_task_test (id,org_code,title) VALUES ('4','W12340004','test0004');
INSERT INTO test_db.t_task_test (id,org_code,title) VALUES ('5','W12340005','test0005');
INSERT INTO test_db.t_task_test (id,org_code,title) VALUES ('6','W12340006','test0006');
SELECT * FROM test_db.t_task_test;
