/*
	README
	- �Ʒ��� ������ ������� ���� �ؾ��Ѵ�.(���������� -> ���̺� ����)
	- Ư�� ������ �����ų���� �� ���� ������ ������ ���� (�����ư Ŭ��  �Ǵ� Ctrl+Enter) �Է� 
	- �������� ���̺��� ������ �� �տ� �ٴ� "CTO"�� ���� �̸����� ���� ������ "SCOTT"�̶�� "SCOTT"���� �ٲ��ش�.
	- ������ �Է�,����(INSERT, UPDATE)�� ���������θ� ����� ���� ��õ�Ѵ�.
	- ��Ÿ ���Ǵ� �ۼ��ڿ��� �����ϼ���.
*/


/* ������ - AUCTION_USER */
CREATE SEQUENCE  "CTO"."AUCTION_USER_SEQ"  MINVALUE 1 MAXVALUE 1000 INCREMENT BY 1 START WITH 4 NOCACHE  NOORDER  NOCYCLE ;
/* ������ - AUCTION_ITEM */
CREATE SEQUENCE  "CTO"."AUCTION_ITEM_SEQ"  MINVALUE 1 MAXVALUE 1000 INCREMENT BY 1 START WITH 2 NOCACHE  NOORDER  NOCYCLE ;

/* ���̺� - AUCTION_USER */

  CREATE TABLE "CTO"."AUCTION_USER" 
   (	"USER_ID" NUMBER(10,0), 
	"USER_NAME" VARCHAR2(20 BYTE), 
	"EMAIL" VARCHAR2(40 BYTE), 
	"PASSWORD" VARCHAR2(20 BYTE), 
	"REGISTER_DATE" DATE, 
	"AUTH" NUMBER(1,0) DEFAULT 1, 
	 PRIMARY KEY ("USER_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
 

  CREATE OR REPLACE TRIGGER "CTO"."TG_AUCTION_USER" 
   before insert on "CTO"."AUCTION_USER" 
   for each row 
begin  
   if inserting then 
      if :NEW."USER_ID" is null then 
         select AUCTION_USER_SEQ.nextval into :NEW."USER_ID" from dual; 
      end if; 
   end if; 
end;

/
ALTER TRIGGER "CTO"."TG_AUCTION_USER" ENABLE;

/* ���̺� - AUCTIONEER_INFO */

  CREATE TABLE "CTO"."AUCTIONEER_INFO" 
   (	"AUCTIONEER_ID" NUMBER(10,0), 
	"LEVEL" NUMBER(1,0) DEFAULT 1, 
	"SATISFACTION" NUMBER(3,0) DEFAULT 0, 
	 PRIMARY KEY ("AUCTIONEER_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE, 
	 CONSTRAINT "FK_AUCTION_USER" FOREIGN KEY ("AUCTIONEER_ID")
	  REFERENCES "CTO"."AUCTION_USER" ("USER_ID") ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
 
 
 
  CREATE TABLE "CTO"."AUCTION_ITEM" 
   (	"AUCTIONEER_ID" NUMBER(10,0), 
	"AUCTION_ID" NUMBER(10,0), 
	"ITEM_NAME" VARCHAR2(20 BYTE), 
	"START_DATE" DATE, 
	"END_DATE" DATE, 
	"STATE" NUMBER(1,0) DEFAULT 1, 
	"CURRENT_BID_AMOUNT" NUMBER(10,0), 
	 CONSTRAINT "PK_AUCTION_ID" PRIMARY KEY ("AUCTION_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE, 
	 CONSTRAINT "FK_AUCTIONEER_ID" FOREIGN KEY ("AUCTIONEER_ID")
	  REFERENCES "CTO"."AUCTION_USER" ("USER_ID") ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
 
 /* ���̺� - AUCTION_ITEM */

  CREATE OR REPLACE TRIGGER "CTO"."TG_AUCTION_ITEM" 
   before insert on "CTO"."AUCTION_ITEM" 
   for each row 
begin  
   if inserting then 
      if :NEW."AUCTION_ID" is null then 
         select AUCTION_ITEM_SEQ.nextval into :NEW."AUCTION_ID" from dual; 
      end if; 
   end if; 
end;

/
ALTER TRIGGER "CTO"."TG_AUCTION_ITEM" ENABLE;

/* ���̺� - AUCTION_BID */

  CREATE TABLE "CTO"."AUCTION_BID" 
   (	"BIDDER_ID" NUMBER(10,0), 
	"AUCTION_ID" NUMBER(10,0), 
	"BIDDING_DATE" DATE, 
	"BID_AMOUNT" NUMBER(10,0), 
	 PRIMARY KEY ("AUCTION_ID", "BIDDER_ID", "BIDDING_DATE")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE, 
	 CONSTRAINT "FK_BIDDER_ID" FOREIGN KEY ("BIDDER_ID")
	  REFERENCES "CTO"."AUCTION_USER" ("USER_ID") ENABLE, 
	 CONSTRAINT "FK_AUCTION_ID" FOREIGN KEY ("AUCTION_ID")
	  REFERENCES "CTO"."AUCTION_ITEM" ("AUCTION_ID") ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
 
/* ���̵����� ���� ���� */
 
select * from AUCTION_USER;

/* ���� ���� */
insert into auction_user (USER_NAME, PASSWORD , EMAIL , REGISTER_DATE) values ('admin', '1111', 'admin@test.com', SYSDATE);
insert into auction_user (USER_NAME, PASSWORD , EMAIL , REGISTER_DATE) values ('user01', '1111', 'user01@test.com', SYSDATE);
insert into auction_user (USER_NAME, PASSWORD , EMAIL , REGISTER_DATE) values ('user02', '1111', 'user02@test.com', SYSDATE);

select * from AUCTIONEER_INFO;

/* �Ǹ��� ��� */ 
insert into auctioneer_info (AUCTIONEER_ID) values (1);
insert into auctioneer_info (AUCTIONEER_ID) values (2);
insert into auctioneer_info (AUCTIONEER_ID) values (3);

select * from AUCTION_ITEM;

/* ��� ��Ǯ ��� */
insert into auction_ITEM (AUCTIONEER_ID, ITEM_NAME, START_DATE, END_DATE, CURRENT_BID_AMOUNT) values (1, 'LOTTO', SYSDATE, SYSDATE+7, 1000);

/* ������ ��� ��ǰ�� ���� ������ ������(�̷� ���� ������ ���� �̷��������) */
update auction_item set current_bid_amount = 1100 where auction_id = 1;
update auction_item set current_bid_amount = 1200 where auction_id = 1;
update auction_item set current_bid_amount = 1300 where auction_id = 1;

select * from AUCTION_BID;

/* �����ڰ� ���ʷ� ���� */
insert into auction_bid (BIDDER_ID, AUCTION_ID, BIDDING_DATE, BID_AMOUNT) values (1, 1, SYSDATE, 1100);
insert into auction_bid (BIDDER_ID, AUCTION_ID, BIDDING_DATE, BID_AMOUNT) values (2, 1, SYSDATE, 1200);
insert into auction_bid (BIDDER_ID, AUCTION_ID, BIDDING_DATE, BID_AMOUNT) values (3, 1, SYSDATE, 1300);

 
 
