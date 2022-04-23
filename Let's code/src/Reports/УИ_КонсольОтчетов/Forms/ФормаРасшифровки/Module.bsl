&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Перем ДанныеРасшифровкиОбъект;

	РеквизитОбъект = РеквизитФормыВЗначение("Отчет");
	ИмяФормыРасшифровки = РеквизитОбъект.Метаданные().ПолноеИмя() + ".Форма.ФормаРасшифровки";

	СтандартнаяОбработка = Ложь;
	Если Параметры.Расшифровка <> Неопределено Тогда
		СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(Параметры.АдресСхемыКомпоновкиДанных);
		АдресСхемыИсполненногоОтчета = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
		ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыИсполненногоОтчета);
		Отчет.КомпоновщикНастроек.Инициализировать(ИсточникДоступныхНастроек);
		ДанныеРасшифровкиОбъект = ПолучитьИзВременногоХранилища(Параметры.Расшифровка.Данные);
		ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(ДанныеРасшифровкиОбъект,
			ИсточникДоступныхНастроек);
		ПрименяемыеНастройки = ОбработкаРасшифровки.ПрименитьНастройки(Параметры.Расшифровка.Идентификатор,
			Параметры.Расшифровка.ПрименяемыеНастройки);
		Если ТипЗнч(ПрименяемыеНастройки) = Тип("НастройкиКомпоновкиДанных") Тогда
			Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(ПрименяемыеНастройки);
		ИначеЕсли ТипЗнч(ПрименяемыеНастройки) = Тип("ПользовательскиеНастройкиКомпоновкиДанных") Тогда
			Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(ДанныеРасшифровкиОбъект.Настройки);
			Отчет.КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(ПрименяемыеНастройки);
		КонецЕсли;

		ВыполнитьНаСервере(СхемаКомпоновкиДанных);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ВыполнитьНаСервере(СхемаКомпоновкиДанных_)
	Перем ДанныеРасшифровкиОбъект;

	Результат.Очистить();

	СхемаКомпоновкиДанных = СхемаКомпоновкиДанных_;
	Если СхемаКомпоновкиДанных = Неопределено Тогда
		СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыИсполненногоОтчета);
	КонецЕсли;

	КомпоновщикМакетаКомпоновкиДанных = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновкиДанных = КомпоновщикМакетаКомпоновкиДанных.Выполнить(СхемаКомпоновкиДанных,
		Отчет.КомпоновщикНастроек.ПолучитьНастройки(), ДанныеРасшифровкиОбъект);

	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных, , ДанныеРасшифровкиОбъект);

	ПроцессорВыводаРезультатаОтчета = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВыводаРезультатаОтчета.УстановитьДокумент(Результат);
	ПроцессорВыводаРезультатаОтчета.НачатьВывод();
	ПроцессорВыводаРезультатаОтчета.Вывести(ПроцессорКомпоновкиДанных);
	ПроцессорВыводаРезультатаОтчета.ЗакончитьВывод();

	АдресДанныхРасшифровки = ПоместитьВоВременноеХранилище(ДанныеРасшифровкиОбъект, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(АдресДанныхРасшифровки,
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыИсполненногоОтчета));
	ОбработкаРасшифровки.ПоказатьВыборДействия(Новый ОписаниеОповещения("РезультатОбработкаРасшифровкиЗавершение1",
		ЭтаФорма, Новый Структура("Расшифровка", Расшифровка)), Расшифровка, , , , );
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровкиЗавершение1(ВыбранноеДействие, ПараметрВыполненногоДействия,
	ДополнительныеПараметры) Экспорт

	Расшифровка = ДополнительныеПараметры.Расшифровка;
	Если ВыбранноеДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.Нет Тогда
	ИначеЕсли ВыбранноеДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение Тогда
		ПоказатьЗначение( , ПараметрВыполненногоДействия);
	Иначе
		ОткрытьФорму(ИмяФормыРасшифровки, Новый Структура("Расшифровка,АдресСхемыКомпоновкиДанных",
			Новый ОписаниеОбработкиРасшифровкиКомпоновкиДанных(АдресДанныхРасшифровки, Расшифровка,
			ПараметрВыполненногоДействия), АдресСхемыИсполненногоОтчета), , Истина);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВариант(Команда)
	ПараметрыФормы=Новый Структура("Вариант, АдресСхемыИсполненногоОтчета", Отчет.КомпоновщикНастроек.Настройки,
		АдресСхемыИсполненногоОтчета);

	ОписаниеОповещенияОЗакрытии=Новый ОписаниеОповещения("ИзменитьВариантЗавершение", ЭтотОбъект);
	ОткрытьФорму("Отчет.УИ_КонсольОтчетов.Форма.ФормаВарианта", ПараметрыФормы, ЭтотОбъект, , , ,
		ОписаниеОповещенияОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВариантЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Истина Тогда
		Возврат;
	КонецЕсли;
	
//		ПользовательскиеНастройки = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки;
//		Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(Форма.Отчет.КомпоновщикНастроек.Настройки);
//		Отчет.КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(ПользовательскиеНастройки);
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	ВыполнитьНаСервере(Неопределено);
КонецПроцедуры