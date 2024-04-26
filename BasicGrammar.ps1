# 日本語を使用する場合は、UTF-8 with BOMで保存すること

# =========================================
# 引数取得
# =========================================
# Mandatory = $true : 必須
# Mandatory = $false : 任意
# Collection, Hashをlaunch.jsonで渡せるか試したが、うまくいかなかった

param (
    [parameter(Mandatory = $true)][string]$argString, # 引数にスペースがあるとエラーになる
    [parameter(Mandatory = $true)][string]$argBoolean, # 下記のように型変換する
    [parameter(Mandatory = $true)][string]$argNumber, # 下記のように型変換する
    [parameter(Mandatory = $true)][string]$argWorkspaceFolderPath
)

# 文字列からBooleanに変換
$ArgBooleanValue = [System.Convert]::ToBoolean($ArgBoolean)

# 文字列から数値に変換
$ArgNumberValue = [int]$ArgNumber

# コマンドラインに出力
Write-Host "引数 文字列型: $ArgString"
Write-Host "引数 Boolean型: $ArgBooleanValue"
Write-Host "引数 数値型: $ArgNumberValue"

# =========================================
# 変数
# =========================================
# 動的型付け言語なので、型宣言なしでよい

# 文字列型
$name = "Suzuki"
Write-Host "My Name is $name"

# 整数型
$age = 27
Write-Host "My age is $age"

# 浮動小数点数型
$price = 19.99
Write-Host "This Price is $price"

# 真偽値型
$isAcceptable = $true
Write-Host "Acceptable? : $isAcceptable"

# 配列型 
# 特定の要素を取り出すには、$()で変数を囲まないといけないので注意
$colors = "red", "green", "blue"
Write-Host "First coloer: $($colors[0])"
Write-Host "Second coloer: $($colors[1])"
Write-Host "Third coloer: $($colors[2])"

# ハッシュテーブル型
$person = @{
    FirstName = "Taro"
    LastName  = "Sato"
    Age       = 27
}
Write-Host "My first name is $($person.FirstName), My last name is $($person.LastName)"


# =========================================
# 定数
# =========================================
Set-Variable -Name PI -Value 3.14159 -Option Constant
Write-Host "The value of PI is $PI" # デバッグ時、既存セッションに定数が残っているとエラーになる

# =========================================
# エスケープシーケンス
# =========================================
$text = "He said `"hello, World!`""
Write-Host $text

# 配列の各要素にかけ算して合計を返す関数
function Get-MultipliedSum {
    [CmdletBinding()]
    param (
        [int[]]$numbers,
        [int]$multiplier
    )

    $sum = 0
    foreach ($number in $numbers) {
        $sum += $number
    }
    return $sum * $multiplier
}

$numbers = 1, 2, 3, 4
$multiplier = 4
$answer = Get-MultipliedSum -numbers $numbers -multiplier $multiplier
Write-Host "回答: $answer"


# パイプラインを使って、ファイル情報を返す関数
function Get-FileInfo {
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string[]]$files
    )
    
    process {
        foreach ($file in $files) {
            if (Test-Path $file) {
                Get-Item $file | Select-Object Name, Length, LastWriteTime
            }
            else {
                Write-Error "File not found: $file"
            }
        }
    }
}
 
function Write-Log {
    param ([string] $logMessage)
    $timeStamp = Get-Date -Format "yyyy/MM/dd HH:mm:ss.fff"
    Write-Host "$timeStamp|$logMessage"
}


# =========================================
# if文
# =========================================
# if-elseif-else文
$number = 20
if ($number -eq 10) {
    Write-Host "The number is 10"
}
elseif ($number -eq 20) {
    Write-Host "The number is 20"
}
else {
    Write-Host "The number is neither 10 nor 20"
}

# if文と論理演算子
$user = "admin"
$password = "secret"
if ($user -eq "admin" -and $password -eq "secret") {
    Write-Host "Access granted."
}
else {
    Write-Host "Access denied."
}

# =========================================
# for文
# =========================================
# 配列のfor文
# 配列のメソッドLengthとCountは実質同じ
$colors = "Red", "Blue", "Green"
for ($i = 0; $i -lt $colors.Count; $i++) {
    Write-Host "The color is $($colors[$i])"
}

# ネストされたfor文
for ($i = 0; $i -lt 5; $i++) {
    for ($j = 0; $j -lt 10; $j++) {
        Write-Host "i is $i, j is $j"
    }
}


# =========================================
# foreach文
# =========================================
# ハッシュテーブルのループ
$person = @{
    Name    = "Jhon Doe"
    Age     = 28
    Country = "USA"
}

foreach ($key in $person.Keys) {
    $value = $person[$key]
    Write-Host "$key : $value"
}

# ファイル内容を繰り返す
$targetFilePath = $argWorkspaceFolderPath + "\\Test.ps1"
$content = Get-Content -Path $targetFilePath
$i = 0
foreach ($line in $content) {
    Write-Host "$i : $line"
    $i += 1
}

# ディレクトリ内のファイルを繰り返す。サブフォルダも再帰的に
$targetDirPath = $argWorkspaceFolderPath
$files = Get-ChildItem -Path $targetDirPath  -Recurse -File
foreach ($file in $files) {
    Write-Host "Found file: $($file.Name)"
}

# =========================================
# switch文
# =========================================
$value = "two"
switch ($value) {
    "one" { Write-Host "The value is one" }
    "two" { Write-Host "The value is two" }
    "three" { Write-Host "The value is three" }
    default { Write-Host "The value is undefined" }
}

# スクリプトブロックを持つswitch文
$value = 0
switch ($value) {
    { $_ -lt 5 } { Write-Host "5未満" }
    { $_ -gt 5 } { Write-Host "5以上" }
    default { Write-Host "undefined" }
}

# ワイルドカードを使用
# うまく機能しない、ダブルクォーテーション、シングルクォーテーションどちらもだめ
$value = "apple"
switch ($value) {
    "a*" { Write-Host 'The value starts with a' }
    "*e" { Write-Host 'The value ends with e' }
    "*l*" { Write-Host 'The value contains with l' }
    Default { Write-Host 'Unmatch' }
}

# ファイル内容を処理 うまく機能しない、ダブルクォーテーションが原因か？
switch -file "C:\\Users\\yoshiaki_suzuki\\Desktop\\MyTest\\PowerShell\\Test.ps1" {
    "Error" { Write-Host "An error has occurred" }
    "Warning" { Write-Host "This is a warning" }
    "Write" { Write-Host "This is a writing proccess" }
    default { Write-Host "Generaal information" }
}


# ループ内 上記と同じでうまくいかない、""が原因か？
$values = "one", "two", "three", "four"

foreach ($value in $values) {
    switch ($value) {
        "one" { Write-Host "1"; break }
        "two" { Write-Host "2"; break }
        "three" { Write-Host "3"; break }
        Default { Write-Host "Oher"; break }
    }
}


# =========================================
# CSV操作
# =========================================
# 基本操作
$csvPath = $argWorkspaceFolderPath + "\\DataSet\\sample.csv"
$csvData = Import-Csv -Path $csvPath
foreach ($row in $csvData) {
    Write-Host "Name: $($row.Name), Age: $($row.Age), Location: $($row.Location)"
}

# フィルタ操作
# $csvDataオブジェクトの中で、特定の文字列を含むものでフィルタリング
Write-Host "=============================="
Write-Host "filterdData"
$filterdData = $csvData | Where-Object { $_.Location -like "New*" }
foreach ($row in $filterdData) {
    Write-Host "Name: $($row.Name), Age: $($row.Age), Location: $($row.Location)"
}

# 置換操作
# Lo を　Diに置換　（CSVは変更なし、オブジェクトだけ変更）
Write-Host "=============================="
Write-Host "Replaced Data"
$filterdData = $csvData
foreach ($row in $filterdData) {
    $row.Location = $row.Location -replace 'Lo', 'Di'
    Write-Host "Name: $($row.Name), Age: $($row.Age), Location: $($row.Location)"
}

# マッピング操作
# Ageを2倍にする
Write-Host "=============================="
Write-Host "Mapped Data"
$filterdData = $csvData # ここでリセットしたつもりだが、文字置換が残存している。なぜ？
foreach ($row in $filterdData) {
    $row.Age = [int]$row.Age * 2
    Write-Host "Name: $($row.Name), Age: $($row.Age), Location: $($row.Location)"
}

# =========================================
# JSON操作
# =========================================
# JSONファイルのパスを指定
$jsonPath = $argWorkspaceFolderPath + "\\DataSet\\sample.json"

# JSONファイルを読み込んでPowerShellオブジェクトに変換
$jsonObject = Get-Content -Path $jsonPath -Raw | ConvertFrom-Json

# オブジェクトの内容を表示
Write-Host "=============================="
Write-Host "JSONデータ"
Write-Host $jsonObject.hobbies

# =========================================
# XML操作
# =========================================
# XMLファイルのパスを指定
$xmlPath = $argWorkspaceFolderPath + "\\DataSet\\sample.xml"

# XMLファイルを読み込む
[xml]$xmlDocument = Get-Content -Path $xmlPath

# XMLデータの内容を表示
Write-Host "=============================="
Write-Host "XMLデータ"
Write-Host $xmlDocument.OuterXml

# XML操作
$harryPotterBook = $xmlDocument.SelectSingleNode("//book[title='Harry Potter']")
# 価格を更新する
if ($null -ne $harryPotterBook) {
    $harryPotterBook.price = "31.99"
}
Write-Host $harryPotterBook.price

# =========================================
# パイプライン
# =========================================

# ファイルの検索と内容の表示
$targetDirPath = $argWorkspaceFolderPath + "\\PowerShell"
$content = Get-ChildItem -Path $targetDirPath -Recurse | 
Where-Object { 
    $_.Extension -eq '.json' -or 
    $_.Extension -eq '.xml'
} | 
Get-Content

Write-Host "============================="
Write-Host "Pipeline"
Write-Host $content