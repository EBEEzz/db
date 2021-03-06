-- 아바타 테이블 추가
CREATE TABLE avatar(
    ano NUMBER(2)
        CONSTRAINT AVT_NO_PK PRIMARY KEY,
    savename VARCHAR2(50 CHAR)
        CONSTRAINT AVT_SNAME_UK UNIQUE
        CONSTRAINT AVT_SNAME_NN NOT NULL,
    dir VARCHAR2(100 CHAR)
        CONSTRAINT AVT_DIR_NN NOT NULL,
    agen CHAR(1) DEFAULT 'N'
        CONSTRAINT AVT_AGEN_CK CHECK(agen IN('F', 'M', 'N'))
        CONSTRAINT AVT_AGEN_NN NOT NULL
);

-- 회원정보 테이블 추가
CREATE TABLE member(
    mno NUMBER(4)
        CONSTRAINT MB_NO_PK PRIMARY KEY,
    name VARCHAR2(20 CHAR)
        CONSTRAINT MB_NAME_NN NOT NULL,
    id VARCHAR2(15 CHAR)
        CONSTRAINT MB_ID_UK UNIQUE
        CONSTRAINT MB_ID_NN NOT NULL,
    pw VARCHAR2(15 CHAR)
        CONSTRAINT MB_PW_NN NOT NULL,
    mail VARCHAR2(50 CHAR)
        CONSTRAINT MB_MAIL_UK UNIQUE
        CONSTRAINT MB_MAIL_NN NOT NULL,
    tel VARCHAR2(13 CHAR)
        CONSTRAINT MB_TEL_UK UNIQUE
        CONSTRAINT MB_TEL_NN NOT NULL,
    gen CHAR(1)
        CONSTRAINT MB_GEN_CK CHECK(gen IN ('F', 'M'))
        CONSTRAINT MB_GEN_NN NOT NULL,
    avt NUMBER(2)
        CONSTRAINT MB_AVT_FK REFERENCES avatar(ano)
        CONSTRAINT MB_AVT_NN NOT NULL,
    jdate DATE DEFAULT sysdate
        CONSTRAINT MB_DATE_NN NOT NULL,
    isshow CHAR(1) DEFAULT 'Y'
        CONSTRAINT MB_SHOW_CK CHECK(isshow IN ('Y', 'N'))
        CONSTRAINT MB_SHOW_NN NOT NULL
);

-- 방명록 테이블 추가
CREATE TABLE guestboard(
    gno NUMBER(4)
        CONSTRAINT GB_NO_PK PRIMARY KEY,
    writer NUMBER(4)
        CONSTRAINT GB_WRITER_FK REFERENCES member(mno)
        CONSTRAINT GB_WRITER_UK UNIQUE
        CONSTRAINT GB_WRITER_NN NOT NULL,
    wdate DATE DEFAULT sysdate
        CONSTRAINT GB_WDATE_NN NOT NULL,
    body VARCHAR2(4000)
        CONSTRAINT GB_BODY_NN NOT NULL
);