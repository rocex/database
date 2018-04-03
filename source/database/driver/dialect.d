module database.driver.dialect;

public import std.variant;

public import database.defined;
public import database.util;
public import database.exception;

interface Dialect
{
    Variant fromSqlValue(DlangDataType fieldType,Variant fieldValue);
    string toSqlValueImpl(DlangDataType type,Variant value);
    string toSqlValue(T)(T val)
    {
        Variant value = val;
        DlangDataType type = getDlangDataType!T(val);
        return toSqlValueImpl(type, value);
    }
}
