#Область ПрограммныйИнтерфейс 

// Функция выполняет проверку наличия полных прав у текущего пользователя 
// Возвращаемое значение:
//		Булево - Результат проверки наличия полных прав
//
Функция ЭтоПолноправныйПользователь() Экспорт
	
	//TODO: Переписать на ПравоДоступа()
	Возврат РольДоступна("ИТК_ПолныеПрава");
	
КонецФункции           

#КонецОбласти