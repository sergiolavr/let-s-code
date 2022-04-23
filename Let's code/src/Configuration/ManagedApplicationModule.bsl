// Хранилище глобальных переменных.
//
// ПараметрыПриложения - Соответствие - хранилище переменных, где:
//   * Ключ - Строка - имя переменной в формате "ИмяБиблиотеки.ИмяПеременной";
//   * Значение - Произвольный - значение переменной.
//
// Инициализация (на примере СообщенияДляЖурналаРегистрации):
//   ИмяПараметра = "СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации";
//   Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
//     ПараметрыПриложения.Вставить(ИмяПараметра, Новый СписокЗначений);
//   КонецЕсли;
//  
// Использование (на примере СообщенияДляЖурналаРегистрации):
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"].Добавить(...);
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"] = ...;   

Перем УИ_ПараметрыПриложения Экспорт;

Процедура ПередНачаломРаботыСистемы(Отказ)

	Если ИТК_ЗадачиТестированияВызовСервера.ЭтоПолноправныйПользователь() Тогда
		КлиентскоеПриложение.УстановитьРежимОсновногоОкна(РежимОсновногоОкнаКлиентскогоПриложения.Обычный);
	КонецЕсли;

КонецПроцедуры

//@skip-warning
&После("ПриНачалеРаботыСистемы")
Процедура УИ_ПриНачалеРаботыСистемы()
	#Если Не МобильныйКлиент Тогда
	УИ_ОбщегоНазначенияКлиент.ПриНачалеРаботыСистемы();	
	#КонецЕсли
КонецПроцедуры

&После("ПриЗавершенииРаботыСистемы")
Процедура УИ_ПриЗавершенииРаботыСистемы()
	#Если Не МобильныйКлиент Тогда
	УИ_ОбщегоНазначенияКлиент.ПриЗавершенииРаботыСистемы();	
	#КонецЕсли
КонецПроцедуры

УИ_ПараметрыПриложения = Новый Соответствие;