/*
 * All Rights Reserved.Copyright (C) 2008, Hitachi Systems & Services,Ltd.
 */
/**************************************************
 !!!!!このファイルは編集しないでください!!!!!
        自動生成されたソースコードです。
        Excelブックを編集してください。

       !!!!!DON'T EDIT THIS FILE!!!!!
 This source code is generated automatically.
 **************************************************/

package jp.co.hisas.career.app.batch.jinik.dto;

import java.io.Serializable;

/**
 * CSTシート排他 Data Transfer Object。
 * @author CareerDaoTool.xla
*/
public class CstSheetExclusiveDto implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * シートID
     */
    private String sheetId;
    /**
     * アクターコード
     */
    private Integer exclusiveKey;

    /**
     * シートIDを取得する。
     * @return シートID
     */
    public String getSheetId() {
        return sheetId;
    }

    /**
     * シートIDを設定する。
     * @param sheetId シートID
     */
    public void setSheetId(String sheetId) {
        this.sheetId = sheetId;
    }

    /**
     * アクターコードを取得する。
     * @return アクターコード
     */
    public Integer getExclusiveKey() {
        return exclusiveKey;
    }

    /**
     * アクターコードを設定する。
     * @param exclusiveKey アクターコード
     */
    public void setExclusiveKey(Integer exclusiveKey) {
        this.exclusiveKey = exclusiveKey;
    }

}

