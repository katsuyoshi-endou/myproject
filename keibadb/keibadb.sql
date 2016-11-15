
/* Drop Tables */

DROP TABLE IF EXISTS MS_COURSE;
DROP TABLE IF EXISTS MS_DISTANCE;
DROP TABLE IF EXISTS MS_LOCATION;
DROP TABLE IF EXISTS MS_RANK;
DROP TABLE IF EXISTS TR_RACE;
DROP TABLE IF EXISTS TR_RACE_FORECAST;
DROP TABLE IF EXISTS TR_RACE_RESULT;
DROP TABLE IF EXISTS TR_WIN_PATTERN;




/* Create Tables */

-- コースマスタ
CREATE TABLE MS_COURSE
(
    -- コース区分
    course_kbn char NOT NULL,
    -- コース名
    course_name varchar(10) NOT NULL,
    -- 登録日
    create_date date NOT NULL,
    -- 更新日
    update_date date,
    -- 削除日
    delete_date date,
    PRIMARY KEY (course_kbn)
) WITHOUT OIDS;


-- 距離マスタ
CREATE TABLE MS_DISTANCE
(
    -- 距離
    distance_kbn char(3) NOT NULL,
    -- 距離名
    distance_name varchar(8) NOT NULL,
    -- 登録日
    create_date date NOT NULL,
    -- 更新日
    update_date date,
    -- 削除日
    delete_date date,
    PRIMARY KEY (distance_kbn)
) WITHOUT OIDS;


-- 開催地マスタ
CREATE TABLE MS_LOCATION
(
    -- 開催地区分
    location_kbn char NOT NULL,
    -- 開催地名
    location_name varchar(16) NOT NULL,
    -- 登録日
    create_date date NOT NULL,
    -- 更新日
    update_date date,
    -- 削除日
    delete_date date,
    PRIMARY KEY (location_kbn)
) WITHOUT OIDS;


-- ランクマスタ
CREATE TABLE MS_RANK
(
    -- ランク
    rank_kbn char NOT NULL,
    -- ランク名
    rank_name varchar(32) NOT NULL,
    -- 登録日
    create_date date NOT NULL,
    -- 更新日
    update_date date,
    -- 削除日
    delete_date date,
    PRIMARY KEY (rank_kbn)
) WITHOUT OIDS;


-- レーステーブル
CREATE TABLE TR_RACE
(
    -- レース識別子
    race_id serial NOT NULL,
    -- 開催日
    open_date date NOT NULL,
    -- 開催地区分
    location_kbn char NOT NULL,
    -- レース番号
    race_number int NOT NULL,
    -- ランク
    rank_kbn char NOT NULL,
    -- コース区分
    course_kbn char NOT NULL,
    -- 距離
    distance_kbn char(3) NOT NULL,
    -- 出走頭数
    race_population int NOT NULL,
    -- 登録日
    create_date date NOT NULL,
    -- 更新日
    update_date date,
    -- 削除日
    delete_date date,
    PRIMARY KEY (race_id),
    UNIQUE (open_date, location_kbn, race_number)
) WITHOUT OIDS;


-- レース予想テーブル
CREATE TABLE TR_RACE_FORECAST
(
    -- レース識別子
    race_id numeric(8) NOT NULL,
    -- コンピ指数1位
    comp_index_1 int NOT NULL,
    -- 指数1位馬番
    horse_number_1 char(2) NOT NULL,
    -- 指数1位馬名
    horse_name_1 varchar(20) NOT NULL,
    -- 指数1位馬斤量
    horse_weight_1 int NOT NULL,
    -- 指数1位前回指数
    last_time_index_1 int DEFAULT 0,
    -- 指数1位コメント
    comment_1 varchar(512),
    -- コンピ指数2位
    comp_index_2 int NOT NULL,
    -- 指数2位馬番
    horse_number_2 char(2) NOT NULL,
    -- 指数2位馬名
    horse_name_2 varchar(20) NOT NULL,
    -- 指数2位馬斤量
    horse_weight_2 int NOT NULL,
    -- 指数2位前回指数
    last_time_index_2 int DEFAULT 0,
    -- 指数2位コメント
    comment_2 varchar(512),
    -- コンピ指数3位
    comp_index_3 int NOT NULL,
    -- 指数3位馬番
    horse_number_3 char(2) NOT NULL,
    -- 指数3位馬名
    horse_name_3 varchar(20) NOT NULL,
    -- 指数3位馬斤量
    horse_weight_3 int NOT NULL,
    -- 指数3位前回指数
    last_time_index_3 int DEFAULT 0,
    -- 指数3位コメント
    comment_3 varchar(512),
    -- コンピ指数4位
    comp_index_4 int DEFAULT 0,
    -- 指数4位馬番
    horse_number_4 char(2),
    -- 指数4位馬名
    horse_name_4 varchar(20),
    -- 指数4位馬斤量
    horse_weight_4 int DEFAULT 0,
    -- 指数4位前回指数
    last_time_index_4 int DEFAULT 0,
    -- 指数4位コメント
    comment_4 varchar(512),
    -- コンピ指数5位
    comp_index_5 int DEFAULT 0,
    -- 指数5位馬番
    horse_number_5 char(2),
    -- 指数5位馬名
    horse_name_5 varchar(20),
    -- 指数5位馬斤量
    horse_weight_5 int DEFAULT 0,
    -- 指数5位前回指数
    last_time_index_5 int DEFAULT 0,
    -- 指数5位コメント
    comment_5 varchar(512),
    -- コンピ指数6位
    comp_index_6 int DEFAULT 0,
    -- 指数6位馬番
    horse_number_6 char(2),
    -- 指数6位馬名
    horse_name_6 varchar(20),
    -- 指数6位馬斤量
    horse_weight_6 int DEFAULT 0,
    -- 指数6位前回指数
    last_time_index_6 int DEFAULT 0,
    -- 指数6位コメント
    comment_6 varchar(512),
    -- コンピ指数7位
    comp_index_7 int DEFAULT 0,
    -- 指数7位馬番
    horse_number_7 char(2),
    -- 指数7位馬名
    horse_name_7 varchar(20),
    -- 指数7位馬斤量
    horse_weight_7 int DEFAULT 0,
    -- 指数7位前回指数
    last_time_index_7 int DEFAULT 0,
    -- 指数7位コメント
    comment_7 varchar(512),
    -- コンピ指数8位
    comp_index_8 int DEFAULT 0,
    -- 指数8位馬番
    horse_number_8 char(2),
    -- 指数8位馬名
    horse_name_8 varchar(20),
    -- 指数8位馬斤量
    horse_weight_8 int DEFAULT 0,
    -- 指数8位前回指数
    last_time_index_8 int DEFAULT 0,
    -- 指数8位コメント
    comment_8 varchar(512),
    -- コンピ指数9位
    comp_index_9 int DEFAULT 0,
    -- 指数9位馬番
    horse_number_9 char(2),
    -- 指数9位馬名
    horse_name_9 varchar(20),
    -- 指数9位馬斤量
    horse_weight_9 int DEFAULT 0,
    -- 指数9位前回指数
    last_time_index_9 int DEFAULT 0,
    -- 指数9位コメント
    comment_9 varchar(512),
    -- コンピ指数10位
    comp_index_10 int DEFAULT 0,
    -- 指数10位馬番
    horse_number_10 char(2),
    -- 指数10位馬名
    horse_name_10 varchar(20),
    -- 指数10位馬斤量
    horse_weight_10 int DEFAULT 0,
    -- 指数10位前回指数
    last_time_index_10 int DEFAULT 0,
    -- 指数10位コメント
    comment_10 varchar(512),
    -- コンピ指数11位
    comp_index_11 int DEFAULT 0,
    -- 指数11位馬番
    horse_number_11 char(2),
    -- 指数11位馬名
    horse_name_11 varchar(20),
    -- 指数11位馬斤量
    horse_weight_11 int DEFAULT 0,
    -- 指数11位前回指数
    last_time_index_11 int DEFAULT 0,
    -- 指数11位コメント
    comment_11 varchar(512),
    -- コンピ指数12位
    comp_index_12 int DEFAULT 0,
    -- 指数12位馬番
    horse_number_12 char(2),
    -- 指数12位馬名
    horse_name_12 varchar(20),
    -- 指数12位馬斤量
    horse_weight_12 int DEFAULT 0,
    -- 指数12位前回指数
    last_time_index_12 int DEFAULT 0,
    -- 指数12位コメント
    comment_12 varchar(512),
    -- コンピ指数13位
    comp_index_13 int DEFAULT 0,
    -- 指数13位馬番
    horse_number_13 char(2),
    -- 指数13位馬名
    horse_name_13 varchar(20),
    -- 指数13位馬斤量
    horse_weight_13 int DEFAULT 0,
    -- 指数13位前回指数
    last_time_index_13 int DEFAULT 0,
    -- 指数13位コメント
    comment_13 varchar(512),
    -- コンピ指数14位
    comp_index_14 int DEFAULT 0,
    -- 指数14位馬番
    horse_number_14 char(2),
    -- 指数14位馬名
    horse_name_14 varchar(20),
    -- 指数14位馬斤量
    horse_weight_14 int DEFAULT 0,
    -- 指数14位前回指数
    last_time_index_14 int DEFAULT 0,
    -- 指数14位コメント
    comment_14 varchar(512),
    -- コンピ指数15位
    comp_index_15 int DEFAULT 0,
    -- 指数15位馬番
    horse_number_15 char(2),
    -- 指数15位馬名
    horse_name_15 varchar(20),
    -- 指数15位馬斤量
    horse_weight_15 int DEFAULT 0,
    -- 指数15位前回指数
    last_time_index_15 int DEFAULT 0,
    -- 指数15位コメント
    comment_15 varchar(512),
    -- コンピ指数16位
    comp_index_16 int DEFAULT 0,
    -- 指数16位馬番
    horse_number_16 char(2),
    -- 指数16位馬名
    horse_name_16 varchar(20),
    -- 指数16位馬斤量
    horse_weight_16 int DEFAULT 0,
    -- 指数16位前回指数
    last_time_index_16 int DEFAULT 0,
    -- 指数16位コメント
    comment_16 varchar(512),
    -- コンピ指数17位
    comp_index_17 int DEFAULT 0,
    -- 指数17位馬番
    horse_number_17 char(2),
    -- 指数17位馬名
    horse_name_17 varchar(20),
    -- 指数17位馬斤量
    horse_weight_17 int DEFAULT 0,
    -- 指数17位前回指数
    last_time_index_17 int DEFAULT 0,
    -- 指数17位コメント
    comment_17 varchar(512),
    -- コンピ指数18位
    comp_index_18 int DEFAULT 0,
    -- 指数18位馬番
    horse_number_18 char(2),
    -- 指数18位馬名
    horse_name_18 varchar(20),
    -- 指数18位馬斤量
    horse_weight_18 int DEFAULT 0,
    -- 指数18位前回指数
    last_time_index_18 int DEFAULT 0,
    -- 指数18位コメント
    comment_18 varchar(512),
    -- レース結果入力済みフラグ
    race_result_flg char DEFAULT '0' NOT NULL,
    -- 登録日
    create_date date NOT NULL,
    -- 更新日
    update_date date,
    -- 削除日
    delete_date date,
    PRIMARY KEY (race_id)
) WITHOUT OIDS;


-- レース結果テーブル
CREATE TABLE TR_RACE_RESULT
(
    -- レース識別子
    race_id numeric(8) NOT NULL,
    -- 1着馬番
    arriving_1_horse_number char(2) NOT NULL,
    -- 2着馬番
    arriving_2_horse_number char(2) NOT NULL,
    -- 3着馬番
    arriving_3_horse_number char(2) NOT NULL,
    -- 4着馬番
    arriving_4_horse_number char(2),
    -- 5着馬番
    arriving_5_horse_number char(2),
    -- 6着馬番
    arriving_6_horse_number char(2),
    -- 7着馬番
    arriving_7_horse_number char(2),
    -- 8着馬番
    arriving_8_horse_number char(2),
    -- 9着馬番
    arriving_9_horse_number char(2),
    -- 10着馬番
    arriving_10_horse_number char(2),
    -- 11着馬番
    arriving_11_horse_number char(2),
    -- 12着馬番
    arriving_12_horse_number char(2),
    -- 13着馬番
    arriving_13_horse_number char(2),
    -- 14着馬番
    arriving_14_horse_number char(2),
    -- 15着馬番
    arriving_15_horse_number char(2),
    -- 16着馬番
    arriving_16_horse_number char(2),
    -- 17着馬番
    arriving_17_horse_number char(2),
    -- 18着馬番
    arriving_18_horse_number char(2),
    -- 分析済みフラグ
    analyze_flg char DEFAULT '0' NOT NULL,
    -- 登録日
    create_date date NOT NULL,
    -- 更新日
    update_date date,
    -- 削除日
    delete_date date,
    PRIMARY KEY (race_id)
) WITHOUT OIDS;


-- 勝利パターンテーブル
CREATE TABLE TR_WIN_PATTERN
(
    -- 勝利パターン識別子
    win_pattern_id serial NOT NULL,
    -- レース識別子
    race_id numeric(8) NOT NULL,
    -- コンピ指数1位
    comp_index_1 int NOT NULL,
    -- コンピ指数2位
    comp_index_2 int NOT NULL,
    -- コンピ指数3位
    comp_index_3 int NOT NULL,
    -- コンピ指数4位
    comp_index_4 int DEFAULT 0,
    -- コンピ指数5位
    comp_index_5 int DEFAULT 0,
    -- 標準偏差
    standard_deviation numeric(3,1) NOT NULL,
    -- 1位馬指数順位
    win_1_index_rank int NOT NULL,
    -- 2位馬指数順位
    win_2_index_rank int NOT NULL,
    -- 馬番組み合わせ
    combination varchar(5) NOT NULL,
    -- 登録日
    create_date date NOT NULL,
    -- 更新日
    update_date date,
    -- 削除日
    delete_date date,
    PRIMARY KEY (win_pattern_id)
) WITHOUT OIDS;



/* Comments */

COMMENT ON TABLE MS_COURSE IS 'コースマスタ';
COMMENT ON COLUMN MS_COURSE.course_kbn IS 'コース区分';
COMMENT ON COLUMN MS_COURSE.course_name IS 'コース名';
COMMENT ON COLUMN MS_COURSE.create_date IS '登録日';
COMMENT ON COLUMN MS_COURSE.update_date IS '更新日';
COMMENT ON COLUMN MS_COURSE.delete_date IS '削除日';
COMMENT ON TABLE MS_DISTANCE IS '距離マスタ';
COMMENT ON COLUMN MS_DISTANCE.distance_kbn IS '距離';
COMMENT ON COLUMN MS_DISTANCE.distance_name IS '距離名';
COMMENT ON COLUMN MS_DISTANCE.create_date IS '登録日';
COMMENT ON COLUMN MS_DISTANCE.update_date IS '更新日';
COMMENT ON COLUMN MS_DISTANCE.delete_date IS '削除日';
COMMENT ON TABLE MS_LOCATION IS '開催地マスタ';
COMMENT ON COLUMN MS_LOCATION.location_kbn IS '開催地区分';
COMMENT ON COLUMN MS_LOCATION.location_name IS '開催地名';
COMMENT ON COLUMN MS_LOCATION.create_date IS '登録日';
COMMENT ON COLUMN MS_LOCATION.update_date IS '更新日';
COMMENT ON COLUMN MS_LOCATION.delete_date IS '削除日';
COMMENT ON TABLE MS_RANK IS 'ランクマスタ';
COMMENT ON COLUMN MS_RANK.rank_kbn IS 'ランク';
COMMENT ON COLUMN MS_RANK.rank_name IS 'ランク名';
COMMENT ON COLUMN MS_RANK.create_date IS '登録日';
COMMENT ON COLUMN MS_RANK.update_date IS '更新日';
COMMENT ON COLUMN MS_RANK.delete_date IS '削除日';
COMMENT ON TABLE TR_RACE IS 'レーステーブル';
COMMENT ON COLUMN TR_RACE.race_id IS 'レース識別子';
COMMENT ON COLUMN TR_RACE.open_date IS '開催日';
COMMENT ON COLUMN TR_RACE.location_kbn IS '開催地区分';
COMMENT ON COLUMN TR_RACE.race_number IS 'レース番号';
COMMENT ON COLUMN TR_RACE.rank_kbn IS 'ランク';
COMMENT ON COLUMN TR_RACE.course_kbn IS 'コース区分';
COMMENT ON COLUMN TR_RACE.distance_kbn IS '距離';
COMMENT ON COLUMN TR_RACE.race_population IS '出走頭数';
COMMENT ON COLUMN TR_RACE.create_date IS '登録日';
COMMENT ON COLUMN TR_RACE.update_date IS '更新日';
COMMENT ON COLUMN TR_RACE.delete_date IS '削除日';
COMMENT ON TABLE TR_RACE_FORECAST IS 'レース予想テーブル';
COMMENT ON COLUMN TR_RACE_FORECAST.race_id IS 'レース識別子';
COMMENT ON COLUMN TR_RACE_FORECAST.comp_index_1 IS 'コンピ指数1位';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_number_1 IS '指数1位馬番';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_name_1 IS '指数1位馬名';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_weight_1 IS '指数1位馬斤量';
COMMENT ON COLUMN TR_RACE_FORECAST.last_time_index_1 IS '指数1位前回指数';
COMMENT ON COLUMN TR_RACE_FORECAST.comment_1 IS '指数1位コメント';
COMMENT ON COLUMN TR_RACE_FORECAST.comp_index_2 IS 'コンピ指数2位';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_number_2 IS '指数2位馬番';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_name_2 IS '指数2位馬名';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_weight_2 IS '指数2位馬斤量';
COMMENT ON COLUMN TR_RACE_FORECAST.last_time_index_2 IS '指数2位前回指数';
COMMENT ON COLUMN TR_RACE_FORECAST.comment_2 IS '指数2位コメント';
COMMENT ON COLUMN TR_RACE_FORECAST.comp_index_3 IS 'コンピ指数3位';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_number_3 IS '指数3位馬番';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_name_3 IS '指数3位馬名';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_weight_3 IS '指数3位馬斤量';
COMMENT ON COLUMN TR_RACE_FORECAST.last_time_index_3 IS '指数3位前回指数';
COMMENT ON COLUMN TR_RACE_FORECAST.comment_3 IS '指数3位コメント';
COMMENT ON COLUMN TR_RACE_FORECAST.comp_index_4 IS 'コンピ指数4位';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_number_4 IS '指数4位馬番';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_name_4 IS '指数4位馬名';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_weight_4 IS '指数4位馬斤量';
COMMENT ON COLUMN TR_RACE_FORECAST.last_time_index_4 IS '指数4位前回指数';
COMMENT ON COLUMN TR_RACE_FORECAST.comment_4 IS '指数4位コメント';
COMMENT ON COLUMN TR_RACE_FORECAST.comp_index_5 IS 'コンピ指数5位';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_number_5 IS '指数5位馬番';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_name_5 IS '指数5位馬名';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_weight_5 IS '指数5位馬斤量';
COMMENT ON COLUMN TR_RACE_FORECAST.last_time_index_5 IS '指数5位前回指数';
COMMENT ON COLUMN TR_RACE_FORECAST.comment_5 IS '指数5位コメント';
COMMENT ON COLUMN TR_RACE_FORECAST.comp_index_6 IS 'コンピ指数6位';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_number_6 IS '指数6位馬番';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_name_6 IS '指数6位馬名';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_weight_6 IS '指数6位馬斤量';
COMMENT ON COLUMN TR_RACE_FORECAST.last_time_index_6 IS '指数6位前回指数';
COMMENT ON COLUMN TR_RACE_FORECAST.comment_6 IS '指数6位コメント';
COMMENT ON COLUMN TR_RACE_FORECAST.comp_index_7 IS 'コンピ指数7位';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_number_7 IS '指数7位馬番';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_name_7 IS '指数7位馬名';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_weight_7 IS '指数7位馬斤量';
COMMENT ON COLUMN TR_RACE_FORECAST.last_time_index_7 IS '指数7位前回指数';
COMMENT ON COLUMN TR_RACE_FORECAST.comment_7 IS '指数7位コメント';
COMMENT ON COLUMN TR_RACE_FORECAST.comp_index_8 IS 'コンピ指数8位';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_number_8 IS '指数8位馬番';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_name_8 IS '指数8位馬名';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_weight_8 IS '指数8位馬斤量';
COMMENT ON COLUMN TR_RACE_FORECAST.last_time_index_8 IS '指数8位前回指数';
COMMENT ON COLUMN TR_RACE_FORECAST.comment_8 IS '指数8位コメント';
COMMENT ON COLUMN TR_RACE_FORECAST.comp_index_9 IS 'コンピ指数9位';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_number_9 IS '指数9位馬番';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_name_9 IS '指数9位馬名';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_weight_9 IS '指数9位馬斤量';
COMMENT ON COLUMN TR_RACE_FORECAST.last_time_index_9 IS '指数9位前回指数';
COMMENT ON COLUMN TR_RACE_FORECAST.comment_9 IS '指数9位コメント';
COMMENT ON COLUMN TR_RACE_FORECAST.comp_index_10 IS 'コンピ指数10位';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_number_10 IS '指数10位馬番';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_name_10 IS '指数10位馬名';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_weight_10 IS '指数10位馬斤量';
COMMENT ON COLUMN TR_RACE_FORECAST.last_time_index_10 IS '指数10位前回指数';
COMMENT ON COLUMN TR_RACE_FORECAST.comment_10 IS '指数10位コメント';
COMMENT ON COLUMN TR_RACE_FORECAST.comp_index_11 IS 'コンピ指数11位';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_number_11 IS '指数11位馬番';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_name_11 IS '指数11位馬名';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_weight_11 IS '指数11位馬斤量';
COMMENT ON COLUMN TR_RACE_FORECAST.last_time_index_11 IS '指数11位前回指数';
COMMENT ON COLUMN TR_RACE_FORECAST.comment_11 IS '指数11位コメント';
COMMENT ON COLUMN TR_RACE_FORECAST.comp_index_12 IS 'コンピ指数12位';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_number_12 IS '指数12位馬番';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_name_12 IS '指数12位馬名';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_weight_12 IS '指数12位馬斤量';
COMMENT ON COLUMN TR_RACE_FORECAST.last_time_index_12 IS '指数12位前回指数';
COMMENT ON COLUMN TR_RACE_FORECAST.comment_12 IS '指数12位コメント';
COMMENT ON COLUMN TR_RACE_FORECAST.comp_index_13 IS 'コンピ指数13位';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_number_13 IS '指数13位馬番';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_name_13 IS '指数13位馬名';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_weight_13 IS '指数13位馬斤量';
COMMENT ON COLUMN TR_RACE_FORECAST.last_time_index_13 IS '指数13位前回指数';
COMMENT ON COLUMN TR_RACE_FORECAST.comment_13 IS '指数13位コメント';
COMMENT ON COLUMN TR_RACE_FORECAST.comp_index_14 IS 'コンピ指数14位';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_number_14 IS '指数14位馬番';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_name_14 IS '指数14位馬名';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_weight_14 IS '指数14位馬斤量';
COMMENT ON COLUMN TR_RACE_FORECAST.last_time_index_14 IS '指数14位前回指数';
COMMENT ON COLUMN TR_RACE_FORECAST.comment_14 IS '指数14位コメント';
COMMENT ON COLUMN TR_RACE_FORECAST.comp_index_15 IS 'コンピ指数15位';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_number_15 IS '指数15位馬番';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_name_15 IS '指数15位馬名';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_weight_15 IS '指数15位馬斤量';
COMMENT ON COLUMN TR_RACE_FORECAST.last_time_index_15 IS '指数15位前回指数';
COMMENT ON COLUMN TR_RACE_FORECAST.comment_15 IS '指数15位コメント';
COMMENT ON COLUMN TR_RACE_FORECAST.comp_index_16 IS 'コンピ指数16位';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_number_16 IS '指数16位馬番';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_name_16 IS '指数16位馬名';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_weight_16 IS '指数16位馬斤量';
COMMENT ON COLUMN TR_RACE_FORECAST.last_time_index_16 IS '指数16位前回指数';
COMMENT ON COLUMN TR_RACE_FORECAST.comment_16 IS '指数16位コメント';
COMMENT ON COLUMN TR_RACE_FORECAST.comp_index_17 IS 'コンピ指数17位';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_number_17 IS '指数17位馬番';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_name_17 IS '指数17位馬名';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_weight_17 IS '指数17位馬斤量';
COMMENT ON COLUMN TR_RACE_FORECAST.last_time_index_17 IS '指数17位前回指数';
COMMENT ON COLUMN TR_RACE_FORECAST.comment_17 IS '指数17位コメント';
COMMENT ON COLUMN TR_RACE_FORECAST.comp_index_18 IS 'コンピ指数18位';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_number_18 IS '指数18位馬番';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_name_18 IS '指数18位馬名';
COMMENT ON COLUMN TR_RACE_FORECAST.horse_weight_18 IS '指数18位馬斤量';
COMMENT ON COLUMN TR_RACE_FORECAST.last_time_index_18 IS '指数18位前回指数';
COMMENT ON COLUMN TR_RACE_FORECAST.comment_18 IS '指数18位コメント';
COMMENT ON COLUMN TR_RACE_FORECAST.race_result_flg IS 'レース結果入力済みフラグ';
COMMENT ON COLUMN TR_RACE_FORECAST.create_date IS '登録日';
COMMENT ON COLUMN TR_RACE_FORECAST.update_date IS '更新日';
COMMENT ON COLUMN TR_RACE_FORECAST.delete_date IS '削除日';
COMMENT ON TABLE TR_RACE_RESULT IS 'レース結果テーブル';
COMMENT ON COLUMN TR_RACE_RESULT.race_id IS 'レース識別子';
COMMENT ON COLUMN TR_RACE_RESULT.arriving_1_horse_number IS '1着馬番';
COMMENT ON COLUMN TR_RACE_RESULT.arriving_2_horse_number IS '2着馬番';
COMMENT ON COLUMN TR_RACE_RESULT.arriving_3_horse_number IS '3着馬番';
COMMENT ON COLUMN TR_RACE_RESULT.arriving_4_horse_number IS '4着馬番';
COMMENT ON COLUMN TR_RACE_RESULT.arriving_5_horse_number IS '5着馬番';
COMMENT ON COLUMN TR_RACE_RESULT.arriving_6_horse_number IS '6着馬番';
COMMENT ON COLUMN TR_RACE_RESULT.arriving_7_horse_number IS '7着馬番';
COMMENT ON COLUMN TR_RACE_RESULT.arriving_8_horse_number IS '8着馬番';
COMMENT ON COLUMN TR_RACE_RESULT.arriving_9_horse_number IS '9着馬番';
COMMENT ON COLUMN TR_RACE_RESULT.arriving_10_horse_number IS '10着馬番';
COMMENT ON COLUMN TR_RACE_RESULT.arriving_11_horse_number IS '11着馬番';
COMMENT ON COLUMN TR_RACE_RESULT.arriving_12_horse_number IS '12着馬番';
COMMENT ON COLUMN TR_RACE_RESULT.arriving_13_horse_number IS '13着馬番';
COMMENT ON COLUMN TR_RACE_RESULT.arriving_14_horse_number IS '14着馬番';
COMMENT ON COLUMN TR_RACE_RESULT.arriving_15_horse_number IS '15着馬番';
COMMENT ON COLUMN TR_RACE_RESULT.arriving_16_horse_number IS '16着馬番';
COMMENT ON COLUMN TR_RACE_RESULT.arriving_17_horse_number IS '17着馬番';
COMMENT ON COLUMN TR_RACE_RESULT.arriving_18_horse_number IS '18着馬番';
COMMENT ON COLUMN TR_RACE_RESULT.analyze_flg IS '分析済みフラグ';
COMMENT ON COLUMN TR_RACE_RESULT.create_date IS '登録日';
COMMENT ON COLUMN TR_RACE_RESULT.update_date IS '更新日';
COMMENT ON COLUMN TR_RACE_RESULT.delete_date IS '削除日';
COMMENT ON TABLE TR_WIN_PATTERN IS '勝利パターンテーブル';
COMMENT ON COLUMN TR_WIN_PATTERN.win_pattern_id IS '勝利パターン識別子';
COMMENT ON COLUMN TR_WIN_PATTERN.race_id IS 'レース識別子';
COMMENT ON COLUMN TR_WIN_PATTERN.comp_index_1 IS 'コンピ指数1位';
COMMENT ON COLUMN TR_WIN_PATTERN.comp_index_2 IS 'コンピ指数2位';
COMMENT ON COLUMN TR_WIN_PATTERN.comp_index_3 IS 'コンピ指数3位';
COMMENT ON COLUMN TR_WIN_PATTERN.comp_index_4 IS 'コンピ指数4位';
COMMENT ON COLUMN TR_WIN_PATTERN.comp_index_5 IS 'コンピ指数5位';
COMMENT ON COLUMN TR_WIN_PATTERN.standard_deviation IS '標準偏差';
COMMENT ON COLUMN TR_WIN_PATTERN.win_1_index_rank IS '1位馬指数順位';
COMMENT ON COLUMN TR_WIN_PATTERN.win_2_index_rank IS '2位馬指数順位';
COMMENT ON COLUMN TR_WIN_PATTERN.combination IS '馬番組み合わせ';
COMMENT ON COLUMN TR_WIN_PATTERN.create_date IS '登録日';
COMMENT ON COLUMN TR_WIN_PATTERN.update_date IS '更新日';
COMMENT ON COLUMN TR_WIN_PATTERN.delete_date IS '削除日';



