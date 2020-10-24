/* описание КП
 * Создаем мини CRM  систему для отслеживания и контроля заказов клиентов и использования данных 
 * в целях увеличения объемов продаж. Т.е. контроль заказов, даты первого и последнегно заказов, 
 * что заказывали, чего не заказывали и чего не было в наличии, но было в заказе и тп.
 * Данный фунционал очень пригодится отделу продаж для построения диалога с клиентами.
 */


-- список клиентов
select * from customers;

-- клиент которй сделал первый заказ
select firstname from customers
where id = (select id from orders where id = 0);

-- клиенты, которые написали пользователя с id = 1
select to_user_id from messages where customers_id = 1;

-- клиенты, заказавшие номенклатурную позицию id = 5
select nomenclature.name , orders.orders_name 
    from nomenclature
        join orders on nomenclature.id = orders.ordered_what 
    where nomenclature.id = 5;
   
-- сгрупируем предыдущий вопрос по nomenclature.id   
select nomenclature.name , orders.orders_name 
    from nomenclature
        join orders on nomenclature.id = orders.ordered_what 
    group by nomenclature.id;
        
-- адрес заказчика и его заказ с id = 5
select customers.address , orders.ordered_what 
    from customers
        join orders on customers.id = orders.orders_name
    where customers.id = 5;

   -- выведем фамилию заказчика и его истроию заказа, где id заказчика = 2
select firstname, order_history.order_history_what
   from customers
       join order_history on customers.id = order_history.order_history_name
   where customers.id = 2;
       
-- созданим представление где будут id клиента и его история заказов
create view cus_order as
select customers.id, order_history.order_history_what 
    from customers, order_history;
   
select * from cus_order
group by cus_order.id;

-- создадим процедуру где будут выводится медиафайлы по популярности(лайки)

create view top_likes as
select media.id, likes.customers_name, count(*)
    from media, likes;
   
select * from top_likes;

-- процедуры \ триггеры

-- триггер для фиксации первого заказа клиента
drop trigger if exists initial_contact;
delimiter //
create trigger initial_contact after insert on orders
for each row 
begin
	case 
	    when 
	        (select count(*) orders_name from orders) = 0
	        then insert into customers (last_one_order)
	        values (now());
        else (select count(*) orders_name from orders) > 0
    end
end //
delimiter ;

-- триггер для фиксации последнего заказа клиента
drop trigger if exists last_contact;
delimiter //
create trigger last_contact after insert on orders
for each row 
begin 
	insert into customers (last_order_date)
	values (now());
end //
delimiter ;














