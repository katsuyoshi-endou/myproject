VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmConnectDB 
   Caption         =   "データベース接続"
   ClientHeight    =   3240
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4470
   OleObjectBlob   =   "frmConnectDB.frx":0000
   StartUpPosition =   1  'オーナー フォームの中央
End
Attribute VB_Name = "frmConnectDB"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit


Rem***************************************************************************
Rem FileName:frmConnectDB
Rem Function:接続情報ダイアログ各処理
Rem Ver-Rev :01-01
Rem***************************************************************************
Rem All Rights Reserved. Copyright (C) 2003, Hitachi Systems & Services, Ltd.
Rem***************************************************************************

Public flgCancel As Boolean             ' ［接続］か［キャンセル］かの処理を振り分けるためのフラグ
Public Show_frmConnectDB_flg As Boolean ' 接続情報ダイアログが強制的に閉じられた場合、DB接続を行わないための処理を実行させるためのフラグ

Rem***************************************************************************
Rem Function:データベース接続情報ダイアログ初期化
Rem Ver-Rev :01-01
Rem***************************************************************************x
Public Sub frmConnectDB_Initialize()
    flgCancel = False               ' 処理フラグをFalseに設定
    Show_frmConnectDB_flg = False   ' 強制的に閉じられた場合のフラグをFalseに設定
    
    frmConnectDB.chkSavePassword.value = True
    
End Sub

Rem***************************************************************************
Rem Function:接続ボタン押下時の処理
Rem Ver-Rev :01-01
Rem***************************************************************************
Private Sub btnConnectDB_Click()
    Dim ret As Integer
   
    ' マウスポインタを砂時計に変更
'    Application.Cursor = xlWait
    
    ' 接続文字列が入力されているかチェックする
    If frmConnectDB.txtConnectString.value = "" Then
        ' エラーメッセージを表示し、フォーカス移動
        ret = MsgBox(EER_DB_CONNECT_STR_NOT_INPUT, vbOKOnly + vbCritical)
        frmConnectDB.txtConnectString.SetFocus
        
        Exit Sub
    End If
    
    ' ユーザ名が入力されているかチェックする
    If frmConnectDB.txtUsername.value = "" Then
        ' エラーメッセージを表示し、フォーカス移動
        ret = MsgBox(EER_DB_USERID_NOT_INPUT, vbOKOnly + vbCritical)
        frmConnectDB.txtUsername.SetFocus
        
        Exit Sub
    End If
    
    ' パスワードが入力されているかチェックする
    If frmConnectDB.txtPassword.value = "" Then
        ' エラーメッセージを表示し、フォーカス移動
        ret = MsgBox(ERR_DB_PASSWORD_NOT_INPUT, vbOKOnly + vbCritical)
        frmConnectDB.txtPassword.SetFocus
        
        Exit Sub
    End If
    
    ' ダイアログに入力された内容をシートに反映
    Worksheets(MAIN_SHEET_NAME).Range(DB_CONNECT_STR_CELL).value = frmConnectDB.txtConnectString.value
    Worksheets(MAIN_SHEET_NAME).Range(DB_USER_NAME_CELL).value = frmConnectDB.txtUsername.value
    
    If chkSavePassword = True Then
        Worksheets(MAIN_SHEET_NAME).Range(DB_PASSWORD_CELL).value = frmConnectDB.txtPassword.value
    End If
        
    Worksheets(MAIN_SHEET_NAME).Range(DB_KEEP_PASSWORD_CELL).value = chkSavePassword
    
    ' 接続開始
    '入力された接続条件でDBMSに接続できるかチェック
    If PZ_chkConnect() = True Then
        ' 接続設定ダイアログを閉じる
        frmConnectDB.Hide
        ' 接続ボタンが押下された場合は閉じる処理のフラグをON状態へ
        frmConnectDB.Show_frmConnectDB_flg = True
    Else
        ' 何らかの原因でデータベースへ接続ができなかった
        ret = MsgBox(ERR_DB_CONNECT, vbOKOnly + vbCritical)
        Exit Sub
    End If
End Sub

Rem***************************************************************************
Rem Function:キャンセルボタン押下時の処理
Rem Ver-Rev :01-01
Rem***************************************************************************
Private Sub btnCancel_Click()
    frmConnectDB.flgCancel = True
    frmConnectDB.Show_frmConnectDB_flg = True    ' 正常にキャンセルボタンが押下されたため閉じる処理のフラグをON状態へ
    frmConnectDB.Hide
End Sub


