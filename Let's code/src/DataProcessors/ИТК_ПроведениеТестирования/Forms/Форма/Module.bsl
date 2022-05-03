#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// подготовка к инициализации редактора кода
	ВерсияСистемы	= Метаданные.Версия;
	
	МакетРедактора = ПолучитьМакетОбработки("РедакторMonaco");
	УИД = Новый УникальныйИдентификатор();
	 
	АдресБиблиотеки = ПоместитьВоВременноеХранилище(МакетРедактора, УИД);
	
	// заполнение общих параметров
	ПостановкаЗадачи = РазметкаВыбериЗадачу(); 
	
	Пользователь = ПолноеИмяПользователя();
	СписокЗадач.Параметры.УстановитьЗначениеПараметра("Пользователь", Пользователь);   
		
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Оповещение = Новый ОписаниеОповещения("ПослеПодключенияРасширенияДляРаботыСФайлами", ЭтотОбъект);
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры  

&НаКлиенте
Процедура ПослеПодключенияРасширенияДляРаботыСФайлами(Подключено, ДопПараметры) Экспорт
	
	Если Подключено Тогда
		
		УстановитьПометкуТемы("СветлаяТема");
		ИзвлечьИсходники();
		
	Иначе
		
		#Если ВебКлиент Тогда
			Если ДопПараметры = Неопределено Тогда
				Оповещение = Новый ОписаниеОповещения("ПослеУстановкиРасширенияДляРаботыСФайлами", ЭтотОбъект);
				НачатьУстановкуРасширенияРаботыСФайлами(Оповещение);
			Иначе
				ПоказатьПредупреждение(, "К сожалению работа в веб-клиенте невозможна!");
			КонецЕсли;
		#КонецЕсли
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеУстановкиРасширенияДляРаботыСФайлами(ДопПараметры) Экспорт
	
	Оповещение = Новый ОписаниеОповещения("ПослеПодключенияРасширенияДляРаботыСФайлами", ЭтотОбъект, Истина);
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	#Если НЕ ВебКлиент Тогда
		
		Если ЗавершениеРаботы = Неопределено ИЛИ НЕ ЗавершениеРаботы Тогда
			
			ПередСтандартнымЗавершениемРаботы(Отказ);
			
		Иначе
			
			Если Модифицированность Тогда
				Отказ = Истина;
				СтандартнаяОбработка = Ложь;
				ТекстПредупреждения = "При закрытии весь несохраненный код будет потерян. Всё равно завершить работу?";
			Иначе
				ЗакрытьОбработку();
			КонецЕсли;
			
		КонецЕсли;
		
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПередСтандартнымЗавершениемРаботы(Отказ)
		
	Если НЕ Модифицированность Тогда
					
		Если ЗначениеЗаполнено(ИндексныйФайл) Тогда
			Отказ = Истина;
			ЗакрытьОбработку();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти  

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоЗадаче(Данные)
	
	Если Данные <> Неопределено И ЗначениеЗаполнено(Данные.Задача) Тогда 
		
		БатлНачат = Истина;
		
		ЗаполнитьПоЗадачеНаСервере(Данные.Задача);
		УстановитьТекст(ТекстАлгоритмаСервер, Неопределено, Ложь);  
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоЗадачеНаСервере(Задача)
	
	ДанныеЗадачи = ИТК_ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Задача, "ПостановкаЗадачи, ШаблонКода, Баллы, Тесты");
	
	ПостановкаЗадачи = СтрШаблон("<html><head></head><body>%1</body></html>", ДанныеЗадачи.ПостановкаЗадачи);
	Баллы = ДанныеЗадачи.Баллы;
	ТекущаяЗадача = Задача;
	
	_СписокТестов = ДанныеЗадачи.Тесты.Выгрузить();
	СписокТестов.Очистить();
	
	Для Каждого СтрокаТест Из _СписокТестов Цикл
		НоваяСтрока = СписокТестов.Добавить();
		НоваяСтрока.Тест = СокрЛП(СтрокаТест.Тест);
		НоваяСтрока.Предустановка = СокрЛП(СтрокаТест.Предустановка);
		НоваяСтрока.Представление = СокрЛП(СтрокаТест.Представление);
	КонецЦикла;
	
	ТекстАлгоритмаСервер = ДанныеЗадачи.ШаблонКода;
	ПротоколТестирования = "";
	ВыполненУспешно = Ложь;
	
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьРешение(Команда)
	
	ТекстАлгоритмаСервер = ПолучитьТекст();
	
	СформироватьПротоколНаСервере();
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаПротоколТестирование;

КонецПроцедуры

&НаСервере
Процедура СформироватьПротоколНаСервере()
	
	РезультатыТестирования = Справочники.ИТК_Задачи.РезультатыТестирования(ТекстАлгоритмаСервер, СписокТестов);
	ПротоколТестирования = РезультатыТестирования.ПротоколТестирования;
	ВыполненУспешно = РезультатыТестирования.ВыполненУспешно;
	
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезагрузитьКод(Команда)
	
	СписокЗадачВыбор(Команда, Неопределено, Неопределено, Ложь);
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаПостановкаЗадачи;
	
КонецПроцедуры

&НаКлиенте
Процедура ОпубликоватьРешение(Команда)

	ОпубликоватьРешениеНаСервере(); 
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаПостановкаЗадачи; 
	ОчиститьТекст();

КонецПроцедуры  

&НаСервере
Процедура ОпубликоватьРешениеНаСервере()
	
	НоваяЗапись = РегистрыСведений.ИТК_РезультатыТестирования.СоздатьМенеджерЗаписи();   
	НоваяЗапись.Задача = ТекущаяЗадача;
	НоваяЗапись.Пользователь = Пользователь;
	НоваяЗапись.Выполнена = Истина;
	НоваяЗапись.Код = ТекстАлгоритмаСервер;
	НоваяЗапись.КоличествоБаллов = Баллы;
	НоваяЗапись.Записать(Истина);
	
	ТекущаяЗадача = Справочники.ИТК_Задачи.ПустаяСсылка();
	ПостановкаЗадачи = РазметкаВыбериЗадачу();
	ПротоколТестирования = "";     
	
	ВыполненУспешно = Ложь;
	Баллы = 0;
		
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеТемами(Команда)
	
	УстановитьПометкуТемы(Команда.Имя);
	ИмяТемы = ПолучитьИмяТемы();
	ПереключитьТему(ИмяТемы);
	
КонецПроцедуры  

&НаКлиенте
Процедура ПереключитьТему(Тема)
	
	Элементы.ПолеАлгоритмаСервер.Документ.monaco.editor.setTheme(Тема);
	
КонецПроцедуры

#КонецОбласти  

#Область ИнициализацияРедактора

&НаКлиенте
Процедура ИнициализацияРедактора()
	
	Инфо = Новый СистемнаяИнформация();
	
	View().init(Инфо.ВерсияПриложения);
	View().setOption("autoResizeEditorLayout", Истина);
	View().setOption("renderQueryDelimiters", Истина);
	View().hideScrollX();
	View().hideScrollY();
	View().enableModificationEvent(Истина);
			
КонецПроцедуры

&НаКлиенте
Процедура ИзвлечьИсходники()
	
	#Если ВебКлиент Тогда
		ПолеАлгоритмаСервер = "https://salexdv.github.io/bsl_console/src/index.html";
		ИсходникиЗагружены = Истина;
	#Иначе
		Оповещение = Новый ОписаниеОповещения("ПриПолученииКаталогаВременныхФайлов", ЭтотОбъект);
		НачатьПолучениеКаталогаВременныхФайлов(Оповещение);
	#КонецЕсли
	
КонецПроцедуры  

&НаКлиенте
Процедура ПриПолученииКаталогаВременныхФайлов(ИмяКаталога, ДопПараметры) Экспорт
	
	КаталогИсходников = ИмяКаталога + "bsl_console\";
	Оповещение = Новый ОписаниеОповещения("ПослеСозданияКаталога", ЭтотОбъект);
	НачатьСозданиеКаталога(Оповещение, КаталогИсходников);
	
КонецПроцедуры   

&НаКлиенте
Процедура ПослеСозданияКаталога(ИмяКаталога, ДопПараметры) Экспорт
	
	Оповещение = Новый ОписаниеОповещения("ПослеПроверкиСуществованияКаталога", ЭтотОбъект);
	ФайлНаДиске = Новый Файл(КаталогИсходников);
	ФайлНаДиске.НачатьПроверкуСуществования(Оповещение);
	
КонецПроцедуры      

&НаКлиенте
Процедура ПослеПроверкиСуществованияКаталога(Существует, ДопПараметры) Экспорт
	
	Если Существует Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеПроверкиСуществованияФайлаВерсии", ЭтотОбъект);
		ФайлНаДиске = Новый Файл(КаталогИсходников + ВерсияСистемы + ".ver");
		ФайлНаДиске.НачатьПроверкуСуществования(Оповещение);
	Иначе		
		ВывестиОшибку("Не удалось создать каталог для исходников", Истина);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПроверкиСуществованияФайлаВерсии(Существует, ДопПараметры) Экспорт
	
	Если Существует Тогда	
		Оповещение = Новый ОписаниеОповещения("ПослеПроверкиСуществованияИндексногоФайла", ЭтотОбъект);
		ФайлНаДиске = Новый Файл(КаталогИсходников + "index.html");
		ФайлНаДиске.НачатьПроверкуСуществования(Оповещение);
	Иначе
		ИзвлечьИсходникиНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры   

&НаКлиенте
Процедура ПослеПроверкиСуществованияИндексногоФайла(Существует, ДопПараметры) Экспорт
	
	Если Существует Тогда		
		ИндексныйФайл = ИндексныйФайл();
		ТочкаВхода = КаталогИсходников + "index.html";
		Оповещение = Новый ОписаниеОповещения("ПослеКопированияИндексногоФайла", ЭтотОбъект);
		НачатьКопированиеФайла(Оповещение, ТочкаВхода, ИндексныйФайл);
	Иначе
		ИзвлечьИсходникиНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеКопированияИндексногоФайла(СкопированныйФайл, ДопПараметры) Экспорт
	
	ПолеАлгоритмаСервер = СкопированныйФайл;
	ИсходникиЗагружены = Истина;
	
КонецПроцедуры 

&НаКлиенте
Процедура ИзвлечьИсходникиНаКлиенте()
	
	Оповещение = Новый ОписаниеОповещения("ПослеУдаленияВременныхФайлов", ЭтотОбъект);
	НачатьУдалениеФайлов(Оповещение, КаталогИсходников, "*.*");
	
КонецПроцедуры       

&НаКлиенте
Процедура ПослеУдаленияВременныхФайлов(ДопПараметры) Экспорт
	
	Оповещение = Новый ОписаниеОповещения("ПослеЗаписиФайлаМакета", ЭтотОбъект);
	ИмяФайла = КаталогИсходников + "bsl_console.zip";
	ДанныеМакета = ПолучитьИзВременногоХранилища(АдресБиблиотеки);
	ДанныеМакета.НачатьЗапись(Оповещение, ИмяФайла);
	
КонецПроцедуры  

&НаКлиенте
Процедура ПослеЗаписиФайлаМакета(ДопПараметры) Экспорт
	
	#Если НЕ ВебКлиент Тогда
	Попытка
		Файл = Новый ЧтениеZipФайла(КаталогИсходников + "bsl_console.zip");
		Файл.ИзвлечьВсе(КаталогИсходников);
		Файл = Новый ЗаписьТекста(КаталогИсходников + ВерсияСистемы + ".ver");
		Файл.ЗаписатьСтроку(ТекущаяДата());
		Файл.Закрыть();
		ТочкаВхода = КаталогИсходников + "index.html";
		ИндексныйФайл = ИндексныйФайл();
		Оповещение = Новый ОписаниеОповещения("ПослеКопированияИндексногоФайла", ЭтотОбъект);
		НачатьКопированиеФайла(Оповещение, ТочкаВхода, ИндексныйФайл);
	Исключение
		ВывестиОшибку("Не удалось извлечь исходники" + Символы.ПС + ОписаниеОшибки(), Истина);
	КонецПопытки;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Функция ИндексныйФайл()
	
	Возврат КаталогИсходников + Формат(ТекущаяУниверсальнаяДатаВМиллисекундах(), "ЧГ=0") + ".html";
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытийПоляРедактора

&НаКлиенте
Процедура ConsoleOnReady(Элемент)
	
	Если ИсходникиЗагружены Тогда
				
		#Если ВебКлиент Тогда
			Если ВебДокументДоступен() Тогда
				ИнициализацияРедактора();
			Иначе
				ПоказатьПредупреждение(, "К сожалению, в веб-клиенте недоступны практически все функции.
				|Вы можете посмотреть только работу автодополнения и подсказок параметров при наборе кода.");
			КонецЕсли;
		#Иначе
			ИнициализацияРедактора();
		#КонецЕсли
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ВебДокументДоступен()
	
	Если Элементы.ПолеАлгоритмаСервер.Документ <> Неопределено
		И Элементы.ПолеHTML.Документ.defaultView <> Неопределено Тогда
		Попытка
			ПолучитьТекст();
			Возврат Истина;
		Исключение
			Возврат Ложь;
		КонецПопытки;
	Иначе
		Возврат Ложь;
	КонецЕсли;
		
КонецФункции

&НаКлиенте
Процедура ОбработатьСобытиеРедактора(Событие)
	
	Если Событие <> Неопределено Тогда
			
		Если Событие.event = "EVENT_QUERY_CONSTRUCT" Тогда
			ВызватьКонструкторЗапроса(Событие.params);
		КонецЕсли;
		
		Если Событие.event = "EVENT_FORMAT_CONSTRUCT" Тогда
			ВызватьКонструкторФорматнойСтроки(Событие.params);
		КонецЕсли;
				
		Если Событие.event = "EVENT_CONTENT_CHANGED" Тогда
			Модифицированность = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ConsoleOnClick(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	Если НЕ ТолькоПросмотр Тогда
		ОбработатьСобытиеРедактора(ДанныеСобытия.Event.eventData1C);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейсРедактора

&НаКлиенте
Функция View()
	
	Возврат Элементы.ПолеАлгоритмаСервер.Документ.defaultView;
	
КонецФункции

&НаКлиенте
Процедура УстановитьТекст(Текст, Позиция, УчитыватьОтступПервойСтроки, Очищать = Истина)    
	
	Если Очищать Тогда
		ОчиститьТекст();
	КонецЕсли;
	
	View().setText(Текст, Позиция, УчитыватьОтступПервойСтроки);
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьТекст()
	
	Возврат View().getText();
	
КонецФункции

&НаКлиенте
Функция ОчиститьТекст()
	
	Возврат View().eraseText();
	
КонецФункции

#КонецОбласти     

 #Область ОбработчикиСобытийЭлементовТаблицыФормыСписокЗадач

&НаКлиенте
Процедура СписокЗадачВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.СписокЗадач.ТекущиеДанные;
	ЗаполнитьПоЗадаче(ТекущиеДанные);
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаПостановкаЗадачи;
	
КонецПроцедуры   

#КонецОбласти    

#Область КонструкторЗапросов

&НаКлиенте
Процедура ПриЗакрытииКонструктораЗапросов(Текст, ДопПараметры) Экспорт
	
	Если Текст <> Неопределено Тогда
		
		Если Не View().queryMode Тогда
			Текст = СтрЗаменить(Текст, Символы.ПС, Символы.ПС + "|");
			Текст = СтрЗаменить(Текст, """", """""");
			Текст = """" + Текст + """";
		КонецЕсли;
		
		УстановитьТекст(Текст, ДопПараметры, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКонструкторЗапроса(Текст, ДопПараметры)
	
	Конструктор = Новый КонструкторЗапроса();
	
	Если ЗначениеЗаполнено(Текст) Тогда
		Попытка
			Конструктор.Текст = Текст;
		Исключение
			Инфо = ИнформацияОбОшибке();
			ПоказатьПредупреждение(, "Ошибка в тексте запроса:" + Символы.ПС + Инфо.Причина.Описание);
			Возврат;
		КонецПопытки;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПриЗакрытииКонструктораЗапросов", ЭтотОбъект, ДопПараметры);
	Конструктор.Показать(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросСоздатьНовыйЗапрос(Ответ, ДопПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОткрытьКонструкторЗапроса("", Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПодготовитьТекстЗапроса(Текст)
	
	ТекстЗапроса = СтрЗаменить(Текст, "|", "");
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, """""", "$");	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, """", "");	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "$", """");
	
	Возврат ТекстЗапроса;
	
КонецФункции

&НаКлиенте
Процедура ВызватьКонструкторЗапроса(ПараметрыЗапроса)
	
	Если ПараметрыЗапроса = Неопределено Тогда
		Оповещение = Новый ОписаниеОповещения("ВопросСоздатьНовыйЗапрос", ЭтотОбъект);
		ТекстВопроса = "Не найден текст запроса." + Символы.ПС + "Создать новый запрос?";
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ТекстЗапроса = ПодготовитьТекстЗапроса(ПараметрыЗапроса.text);
		ОткрытьКонструкторЗапроса(ТекстЗапроса, ПараметрыЗапроса.range);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область КонструкторФорматнойСтроки

&НаКлиенте
Процедура ПриЗакрытииКонструктораФорматнойСтроки(ФорматнаяСтрока, ДопПараметры) Экспорт
	
	Если ФорматнаяСтрока <> Неопределено Тогда	
		ФорматнаяСтрока = СтрЗаменить(ФорматнаяСтрока, "'", "");
		ФорматнаяСтрока = """" + ФорматнаяСтрока + """";
		УстановитьТекст(ФорматнаяСтрока, ДопПараметры, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКонструкторФорматнойСтроки(ФорматнаяСтрока, ДопПараметры)
	
	Конструктор = Новый КонструкторФорматнойСтроки();
	Попытка			
		Конструктор.Текст = ФорматнаяСтрока;
	Исключение
		Инфо = ИнформацияОбОшибке();
		ПоказатьПредупреждение(, "Ошибка в тексте форматной строки:" + Символы.ПС + Инфо.Причина.Описание);
		Возврат;
	КонецПопытки;
	Оповещение = Новый ОписаниеОповещения("ПриЗакрытииКонструктораФорматнойСтроки", ЭтотОбъект, ДопПараметры);
	Конструктор.Показать(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросСоздатьНовуюФорматнуюСтроку(Ответ, ДопПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОткрытьКонструкторФорматнойСтроки("", Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВызватьКонструкторФорматнойСтроки(ПараметрыСтроки)
	
	Если ПараметрыСтроки = Неопределено Тогда
		Оповещение = Новый ОписаниеОповещения("ВопросСоздатьНовуюФорматнуюСтроку", ЭтотОбъект);
		ТекстВопроса = "Форматная строка не найдена." + Символы.ПС + "Создать новую форматную строку?";
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ФорматнаяСтрока = СтрЗаменить(СтрЗаменить(ПараметрыСтроки.text, "|", ""), """", "");
		ОткрытьКонструкторФорматнойСтроки(ФорматнаяСтрока, ПараметрыСтроки.range);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЭтотОбъект()
	
	Возврат РеквизитФормыВЗначение("Объект");
	
КонецФункции

&НаСервере
Функция ПолучитьМакетОбработки(ИмяМакета)
	
	Возврат ЭтотОбъект().ПолучитьМакет(ИмяМакета);
	
КонецФункции

&НаКлиенте
Процедура УстановитьПометкуТемы(Тема)
	
	Для Каждого Элемент Из Элементы.Тема.ПодчиненныеЭлементы Цикл
		Элемент.Пометка = (Элемент.Имя = Тема);
	КонецЦикла;
	
КонецПроцедуры 

&НаСервере
Процедура ОбновитьВидимостьДоступность()
	
	Элементы.ПроверитьРешение.Видимость = НЕ ВыполненУспешно;
	Элементы.ОпубликоватьРешение.Видимость = ВыполненУспешно;
	
	Элементы.ПолеАлгоритмаСервер.Доступность = НЕ ВыполненУспешно;
	
	ОбновитьПараметрыПоУчастнику();
		
КонецПроцедуры

&НаСервере
Процедура ОбновитьПараметрыПоУчастнику()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СУММА(РезультатыТестирования.КоличествоБаллов) КАК КоличествоБаллов,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ РезультатыТестирования.Задача) КАК КоличествоРешенныхЗадач
		|ИЗ
		|	РегистрСведений.ИТК_РезультатыТестирования КАК РезультатыТестирования
		|ГДЕ
		|	РезультатыТестирования.Пользователь = &Пользователь";
	
	Выборка = Запрос.Выполнить().Выбрать(); 
	Выборка.Следующий();
	
	КоличествоРешенныхЗадач = Выборка.КоличествоРешенныхЗадач;
	КоличествоБаллов = Выборка.КоличествоБаллов;	
	
КонецПроцедуры
         
&НаКлиенте
Функция ПолучитьИмяТемы()
	
	ИмяТемы = Неопределено;
	
	Имена = Новый Соответствие();
	Имена.Вставить("СветлаяТема", "bsl-white");
	Имена.Вставить("ТемнаяТема", "bsl-dark");
	
	Для Каждого Элемент Из Элементы.Тема.ПодчиненныеЭлементы Цикл
		Если Элемент.Пометка Тогда
			ИмяТемы = Имена[Элемент.Имя];
		КонецЕсли;
	КонецЦикла;
	
	Возврат ИмяТемы;
	
КонецФункции

&НаКлиенте
Процедура ВывестиОшибку(Текст, Закрывать)
	
	ПараметрыОповещения = Новый Структура("Закрывать", Закрывать);
	Оповещение = Новый ОписаниеОповещения("ПослеВыводаОшибки", ЭтотОбъект, ПараметрыОповещения);
	ПоказатьПредупреждение(Оповещение, Текст);
	
КонецПроцедуры  

&НаКлиенте
Процедура ПослеВыводаОшибки(ДопПараметры) Экспорт
	
	Если ДопПараметры.Закрывать Тогда
		ЗакрытьОбработку();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьОбработку()
	
	Если ЗначениеЗаполнено(ИндексныйФайл) Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеУдаленияИндексногоФайла", ЭтотОбъект);
		НачатьУдалениеФайлов(Оповещение, ИндексныйФайл);
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры  

&НаКлиенте
Процедура ПослеУдаленияИндексногоФайла(ДопПараметры) Экспорт
	
	ИндексныйФайл = "";
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РазметкаВыбериЗадачу()

	Возврат СтрШаблон("<html><head></head><body><h3>%1</h3></body>", "Выбери задачу из списка...");	
	
КонецФункции

#КонецОбласти 