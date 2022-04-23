
&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	
  	СтандартнаяОбработка = Ложь;
    
    СтруктураРасшифровки = Новый Структура("Задача, Пользователь");
    ПолучитьДанныеРасшифровкиСоСтруктурой(Расшифровка, СтруктураРасшифровки);
	
	СписокКнопок = Новый СписокЗначений;
	СписокКнопок.Добавить(КодВозвратаДиалога.Да, "Добавить бал");
	СписокКнопок.Добавить(КодВозвратаДиалога.Нет, "Убавить бал");
	СписокКнопок.Добавить(КодВозвратаДиалога.Отмена, "Ничего");
	
	ПоказатьВопрос(
		Новый ОписаниеОповещения("РезультатОбработкаРасшифровкиЗавершение",
			ЭтаФорма, Новый Структура("СтруктураРасшифровки", СтруктураРасшифровки)), "Что делаем?", СписокКнопок);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровкиЗавершение(РезультатВопроса, ДополнительныеПараметры1) Экспорт
	
	СтруктураРасшифровки = ДополнительныеПараметры1.СтруктураРасшифровки;
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ДобавитьБалПоЗадаче(СтруктураРасшифровки, 1);
		СкомпоноватьРезультат(РежимКомпоновкиРезультата.Непосредственно);
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		ДобавитьБалПоЗадаче(СтруктураРасшифровки, -1);
		СкомпоноватьРезультат(РежимКомпоновкиРезультата.Непосредственно);	
	КонецЕсли;

КонецПроцедуры   

&НаКлиенте
Процедура ДобавитьБалПоЗадаче(СтруктураРасшифровки, СколькоБаллов)

	ДобавитьБалПоЗадачеНаСервере(СтруктураРасшифровки, СколькоБаллов);	
	
КонецПроцедуры
    
&НаСервере
Процедура ДобавитьБалПоЗадачеНаСервере(СтруктураРасшифровки, СколькоБаллов)

	МененджерЗаписи = РегистрыСведений.ИТК_РезультатыТестирования.СоздатьМенеджерЗаписи(); 
	МененджерЗаписи.Задача = СтруктураРасшифровки.Задача;
	МененджерЗаписи.Пользователь = СтруктураРасшифровки.Пользователь;
	МененджерЗаписи.Прочитать(); 
	
	МененджерЗаписи.КоличествоБаллов = МененджерЗаписи.КоличествоБаллов + СколькоБаллов;
	МененджерЗаписи.Записать(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСтруктуруВозврата(ПолеИлиГруппировка, СтруктураПолей) 

	МассивРодителей = ПолеИлиГруппировка.ПолучитьРодителей();
	Для Каждого Стр из МассивРодителей Цикл
		Если ТипЗнч(Стр) = Тип("ЭлементРасшифровкиКомпоновкиДанныхГруппировка") Тогда 
			ПолучитьСтруктуруВозврата(Стр,СтруктураПолей);
		ИначеЕсли ТипЗнч(Стр) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
			ПоляГруппировки = Стр.ПолучитьПоля();
			Для Каждого гСтр из ПоляГруппировки Цикл
				Если СтруктураПолей.Свойство(гСтр.Поле) Тогда
					Если Не ЗначениеЗаполнено(СтруктураПолей[гСтр.Поле]) Тогда
						СтруктураПолей[гСтр.Поле] = гСтр.Значение;
					КонецЕсли;
				КонецЕсли;
				ПолучитьСтруктуруВозврата(Стр, СтруктураПолей);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла; 
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеРасшифровкиСоСтруктурой(Расшифровка, СтруктураВозврата); 
	
	Данные = ПолучитьИзВременногоХранилища(ДанныеРасшифровки); 
	ПолучитьСтруктуруВозврата(Данные.Элементы[Расшифровка], СтруктураВозврата);  
	
КонецФункции // ПолучитьДанныеРасшифровки()
