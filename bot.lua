 		return true
  	else
     		print("\n\27[32m  لازمه کارکرد صحیح ، فرامین و امورات مدیریتی ربات سین گر <<\n                    تعریف کاربری به عنوان مدیر است\n\27[34m                   ایدی خود را به عنوان مدیر وارد کنید\n\27[32m    شما می توانید از ربات زیر شناسه عددی خود را بدست اورید\n\27[34m        ربات:       @id_ProBot")
 -    		print("\n\27[32m >> Tabchi Bot need a fullaccess user (ADMIN)\n\27[34m Imput Your ID as the ADMIN\n\27[32m You can get your ID of this bot\n\27[34m                 @id_ProBot")
 -    		print("\n\27[36m                      : شناسه عددی ادمین را وارد کنید << \n >> Imput the Admin ID :\n\27[31m                 ")
 -    		admin=io.read()
 +    	print("\n\27[32m >> Tabchi Bot need a fullaccess user (ADMIN)\n\27[34m Imput Your ID as the ADMIN\n\27[32m You can get your ID of this bot\n\27[34m                 @id_ProBot")
 +    	print("\n\27[36m                      : شناسه عددی ادمین را وارد کنید << \n >> Imput the Admin ID :\n\27[31m                 ")
 +    	local admin=io.read()
  		redis:del("botBOT-IDadmin")
 -    		redis:sadd("botBOT-IDadmin", admin)
 +    	redis:sadd("botBOT-IDadmin", admin)
  		redis:set('botBOT-IDadminset',true)
 -  	end
 -  	return print("\n\27[36m     ADMIN ID |\27[32m ".. admin .." \27[36m| شناسه ادمین")
 +    	return print("\n\27[36m     ADMIN ID |\27[32m ".. admin .." \27[36m| شناسه ادمین")
 +	end
  end
  function get_bot (i, naji)
  	function bot_info (i, naji)
 @@ -55,7 +55,7 @@ end
  function process_join(i, naji)
  	if naji.code_ == 429 then
  		local message = tostring(naji.message_)
 -		local Time = message:match('%d+')
 +		local Time = message:match('%d+') + 85
  		redis:setex("botBOT-IDmaxjoin", tonumber(Time), true)
  	else
  		redis:srem("botBOT-IDgoodlinks", i.link)
 @@ -68,7 +68,7 @@ function process_link(i, naji)
  		redis:sadd("botBOT-IDgoodlinks", i.link)
  	elseif naji.code_ == 429 then
  		local message = tostring(naji.message_)
 -		local Time = message:match('%d+')
 +		local Time = message:match('%d+') + 85
  		redis:setex("botBOT-IDmaxlink", tonumber(Time), true)
  	else
  		redis:srem("botBOT-IDwaitelinks", i.link)
 @@ -119,6 +119,14 @@ function rem(id)
  	return true
  end
  function send(chat_id, msg_id, text)
 +	 tdcli_function ({
 +    ID = "SendChatAction",
 +    chat_id_ = chat_id,
 +    action_ = {
 +      ID = "SendMessageTypingAction",
 +      progress_ = 100
 +    }
 +  }, cb or dl_cb, cmd)
  	tdcli_function ({
  		ID = "SendMessage",
  		chat_id_ = chat_id,
 @@ -137,38 +145,34 @@ function send(chat_id, msg_id, text)
  	}, dl_cb, nil)
  end
  get_admin()
 +redis:set("botBOT-IDstart", true)
  function tdcli_update_callback(data)
  	if data.ID == "UpdateNewMessage" then
  		if not redis:get("botBOT-IDmaxlink") then
  			if redis:scard("botBOT-IDwaitelinks") ~= 0 then
  				local links = redis:smembers("botBOT-IDwaitelinks")
 -				for x,y in pairs(links) do
 -					if x == 11 then redis:setex("botBOT-IDmaxlink", 60, true) return end
 +				for x,y in ipairs(links) do
 +					if x == 6 then redis:setex("botBOT-IDmaxlink", 65, true) return end
  					tdcli_function({ID = "CheckChatInviteLink",invite_link_ = y},process_link, {link=y})
  				end
  			end
  		end
  		if not redis:get("botBOT-IDmaxjoin") then
 -			if redis:scard("botBOT-IDgoodlinks") ~= 0 then 
 +			if redis:scard("botBOT-IDgoodlinks") ~= 0 then
  				local links = redis:smembers("botBOT-IDgoodlinks")
 -				for x,y in pairs(links) do
 +				for x,y in ipairs(links) do
  					tdcli_function({ID = "ImportChatInviteLink",invite_link_ = y},process_join, {link=y})
 -					if x == 5 then redis:setex("botBOT-IDmaxjoin", 60, true) return end
 +					if x == 2 then redis:setex("botBOT-IDmaxjoin", 65, true) return end
  				end
  			end
  		end
  		local msg = data.message_
  		local bot_id = redis:get("botBOT-IDid") or get_bot()
  		if (msg.sender_user_id_ == 777000 or msg.sender_user_id_ == 178220800) then
 -			for k,v in pairs(redis:smembers('botBOT-IDadmin')) do
 -				tdcli_function({
 -					ID = "ForwardMessages",
 -					chat_id_ = v,
 -					from_chat_id_ = msg.chat_id_,
 -					message_ids_ = {[0] = msg.id_},
 -					disable_notification_ = 0,
 -					from_background_ = 1
 -				}, dl_cb, nil)
 +			local c = (msg.content_.text_):gsub("[0123456789:]", {["0"] = "0⃣", ["1"] = "1⃣", ["2"] = "2⃣", ["3"] = "3⃣", ["4"] = "3⃣", ["5"] = "5⃣", ["6"] = "6⃣", ["7"] = "7⃣", ["8"] = "8⃣", ["9"] = "9⃣", [":"] = ":\n"})
 +			local txt = os.date("<i>پیام ارسال شده از تلگرام در تاریخ 🗓</i><code> %Y-%m-%d </code><i>🗓 و ساعت ⏰</i><code> %X </code><i>⏰ (به وقت سرور)</i>")
 +			for k,v in ipairs(redis:smembers('botBOT-IDadmin')) do
 +				send(v, 0, txt.."\n\n"..c)
  			end
  		end
  		if tostring(msg.chat_id_):match("^(%d+)") then
 @@ -184,9 +188,82 @@ function tdcli_update_callback(data)
  		if msg.content_.ID == "MessageText" then
  			local text = msg.content_.text_
  			local matches
 -			find_link(text)
 +			if redis:get("botBOT-IDlink") then
 +				find_link(text)
 +			end
  			if is_naji(msg) then
 -				if text:match("^(افزودن مدیر) (%d+)$") then
 +				find_link(text)
 +				if text:match("^(حذف لینک) (.*)$") then
 +					local matches = text:match("^حذف لینک (.*)$")
 +					if matches == "عضویت" then
 +						redis:del("botBOT-IDgoodlinks")
 +						return send(msg.chat_id_, msg.id_, "لیست لینک های در انتظار عضویت پاکسازی شد.")
 +					elseif matches == "تایید" then
 +						redis:del("botBOT-IDwaitelinks")
 +						return send(msg.chat_id_, msg.id_, "لیست لینک های در انتظار تایید پاکسازی شد.")
 +					elseif matches == "ذخیره شده" then
 +						redis:del("botBOT-IDsavedlinks")
 +						return send(msg.chat_id_, msg.id_, "لیست لینک های ذخیره شده پاکسازی شد.")
 +					end
 +				elseif text:match("^(حذف کلی لینک) (.*)$") then
 +					local matches = text:match("^حذف کلی لینک (.*)$")
 +					if matches == "عضویت" then
 +						local list = redis:smembers("botBOT-IDgoodlinks")
 +						for i, v in ipairs(list) do
 +							redis:srem("botBOT-IDalllinks", v)
 +						end
 +						send(msg.chat_id_, msg.id_, "لیست لینک های در انتظار عضویت بطورکلی پاکسازی شد.")
 +						redis:del("botBOT-IDgoodlinks")
 +					elseif matches == "تایید" then
 +						local list = redis:smembers("botBOT-IDwaitelinks")
 +						for i, v in ipairs(list) do
 +							redis:srem("botBOT-IDalllinks", v)
 +						end
 +						send(msg.chat_id_, msg.id_, "لیست لینک های در انتظار تایید بطورکلی پاکسازی شد.")
 +						redis:del("botBOT-IDwaitelinks")
 +					elseif matches == "ذخیره شده" then
 +						local list = redis:smembers("botBOT-IDsavedlinks")
 +						for i, v in ipairs(list) do
 +							redis:srem("botBOT-IDalllinks", v)
 +						end
 +						send(msg.chat_id_, msg.id_, "لیست لینک های ذخیره شده بطورکلی پاکسازی شد.")
 +						redis:del("botBOT-IDsavedlinks")
 +					end
 +				elseif text:match("^(توقف) (.*)$") then
 +					local matches = text:match("^توقف (.*)$")
 +					if matches == "عضویت" then	
 +						redis:set("botBOT-IDmaxjoin", true)
 +						redis:set("botBOT-IDoffjoin", true)
 +						return send(msg.chat_id_, msg.id_, "فرایند عضویت خودکار متوقف شد.")
 +					elseif matches == "تایید لینک" then	
 +						redis:set("botBOT-IDmaxlink", true)
 +						redis:set("botBOT-IDofflink", true)
 +						return send(msg.chat_id_, msg.id_, "فرایند تایید لینک در های در انتظار متوقف شد.")
 +					elseif matches == "شناسایی لینک" then	
 +						redis:del("botBOT-IDlink")
 +						return send(msg.chat_id_, msg.id_, "فرایند شناسایی لینک متوقف شد.")
 +					elseif matches == "افزودن مخاطب" then	
 +						redis:del("botBOT-IDsavecontacts")
 +						return send(msg.chat_id_, msg.id_, "فرایند افزودن خودکار مخاطبین به اشتراک گذاشته شده متوقف شد.")
 +					end
 +				elseif text:match("^(شروع) (.*)$") then
 +					local matches = text:match("^شروع (.*)$")
 +					if matches == "عضویت" then	
 +						redis:del("botBOT-IDmaxjoin")
 +						redis:del("botBOT-IDoffjoin")
 +						return send(msg.chat_id_, msg.id_, "فرایند عضویت خودکار فعال شد.")
 +					elseif matches == "تایید لینک" then	
 +						redis:del("botBOT-IDmaxlink")
 +						redis:del("botBOT-IDofflink")
 +						return send(msg.chat_id_, msg.id_, "فرایند تایید لینک های در انتظار فعال شد.")
 +					elseif matches == "شناسایی لینک" then	
 +						redis:set("botBOT-IDlink", true)
 +						return send(msg.chat_id_, msg.id_, "فرایند شناسایی لینک فعال شد.")
 +					elseif matches == "افزودن مخاطب" then	
 +						redis:set("botBOT-IDsavecontacts", true)
 +						return send(msg.chat_id_, msg.id_, "فرایند افزودن خودکار مخاطبین به اشتراک  گذاشته شده فعال شد.")
 +					end
 +				elseif text:match("^(افزودن مدیر) (%d+)$") then
  					local matches = text:match("%d+")
  					if redis:sismember('botBOT-IDadmin', matches) then
  						return send(msg.chat_id_, msg.id_, "<i>کاربر مورد نظر در حال حاضر مدیر است.</i>")
 @@ -392,8 +469,8 @@ function tdcli_update_callback(data)
  					}, function (i, naji)
  						redis:set("botBOT-IDcontacts", naji.total_count_)
  					end, nil)
 -					for i, v in pairs(list) do
 -							for a, b in pairs(v) do 
 +					for i, v in ipairs(list) do
 +							for a, b in ipairs(v) do 
  								tdcli_function ({
  									ID = "GetChatMember",
  									chat_id_ = b,
 @@ -406,16 +483,20 @@ function tdcli_update_callback(data)
  					end
  					return send(msg.chat_id_,msg.id_,"<i>تازه‌سازی آمار سین‌گر شماره </i><code> BOT-ID </code> با موفقیت انجام شد.")
  				elseif text:match("^(وضعیت)$") then
 -					local s = redis:get("botBOT-IDmaxjoin") and redis:ttl("botBOT-IDmaxjoin") or 0
 -					local ss = redis:get("botBOT-IDmaxlink") and redis:ttl("botBOT-IDmaxlink") or 0
 -					local msgadd = redis:get("botBOT-IDaddmsg") and "☑️" or "❎"
 -					local numadd = redis:get("botBOT-IDaddcontact") and "✅" or "❎"
 +					local s =  redis:get("botBOT-IDoffjoin") and 0 or redis:get("botBOT-IDmaxjoin") and redis:ttl("botBOT-IDmaxjoin") or 0
 +					local ss = redis:get("botBOT-IDofflink") and 0 or redis:get("botBOT-IDmaxlink") and redis:ttl("botBOT-IDmaxlink") or 0
 +					local msgadd = redis:get("botBOT-IDaddmsg") and "✅" or "⛔️"
 +					local numadd = redis:get("botBOT-IDaddcontact") and "✅" or "⛔️"
  					local txtadd = redis:get("botBOT-IDaddmsgtext") or  "اد‌دی گلم پیوی پیام بده"
 -					local autoanswer = redis:get("botBOT-IDautoanswer") and "✅" or "❎"
 +					local autoanswer = redis:get("botBOT-IDautoanswer") and "✅" or "⛔️"
  					local wlinks = redis:scard("botBOT-IDwaitelinks")
  					local glinks = redis:scard("botBOT-IDgoodlinks")
  					local links = redis:scard("botBOT-IDsavedlinks")
 -					local txt = "<i>⚙ وضعیت اجرای یسین گر</i><code> BOT-ID </code>⛓\n\n" .. tostring(autoanswer) .."<code> حالت پاسخگویی خودکار 🗣 </code>\n" .. tostring(numadd) .. "<code> افزودن مخاطب با شماره 📞 </code>\n" .. tostring(msgadd) .. "<code> افزودن مخاطب با پیام 🗞</code>\n〰〰〰ا〰〰〰\n<code>📄 پیام افزودن مخاطب :</code>\n📍 " .. tostring(txtadd) .. " 📍\n〰〰〰ا〰〰〰\n<code>📁 لینک های ذخیره شده : </code><b>" .. tostring(links) .. "</b>\n<code>⏲	لینک های در انتظار عضویت : </code><b>" .. tostring(glinks) .. "</b>\n🕖   <b>" .. tostring(s) .. " </b><code>ثانیه تا عضویت مجدد</code>\n<code>❄️ لینک های در انتظار تایید : </code><b>" .. tostring(wlinks) .. "</b>\n🕑   <b>" .. tostring(ss) .. " </b><code>ثانیه تا تایید لینک مجدد</code>\n 😼 سازنده : @i_naji"
 +					local offjoin = redis:get("botBOT-IDoffjoin") and "⛔️" or "✅"
 +					local offlink = redis:get("botBOT-IDofflink") and "⛔️" or "✅"
 +					local nlink = redis:get("botBOT-IDlink") and "✅" or "⛔️"
 +					local contacts = redis:get("botBOT-IDsavecontacts") and "✅" or "⛔️"
 +					local txt = "⚙  <i>وضعیت اجرایی سین گر</i><code> BOT-ID</code>  ⛓\n\n"..tostring(offjoin).."<code> عضویت خودکار </code>🚀\n"..tostring(offlink).."<code> تایید لینک خودکار </code>🚦\n"..tostring(nlink).."<code> تشخیص لینک های عضویت </code>🎯\n"..tostring(contacts).."<code> افزودن خودکار مخاطبین </code>➕\n" .. tostring(autoanswer) .."<code> حالت پاسخگویی خودکار 🗣 </code>\n" .. tostring(numadd) .. "<code> افزودن مخاطب با شماره 📞 </code>\n" .. tostring(msgadd) .. "<code> افزودن مخاطب با پیام 🗞</code>\n〰〰〰ا〰〰〰\n📄<code> پیام افزودن مخاطب :</code>\n📍 " .. tostring(txtadd) .. " 📍\n〰〰〰ا〰〰〰\n\n<code>📁 لینک های ذخیره شده : </code><b>" .. tostring(links) .. "</b>\n<code>⏲	لینک های در انتظار عضویت : </code><b>" .. tostring(glinks) .. "</b>\n🕖   <b>" .. tostring(s) .. " </b><code>ثانیه تا عضویت مجدد</code>\n<code>❄️ لینک های در انتظار تایید : </code><b>" .. tostring(wlinks) .. "</b>\n🕑   <b>" .. tostring(ss) .. " </b><code>ثانیه تا تایید لینک مجدد</code>\n\n 😼 سازنده : @i_naji"
  					return send(msg.chat_id_, 0, txt)
  				elseif text:match("^(امار)$") or text:match("^(آمار)$") then
  					local gps = redis:scard("botBOT-IDgroups")
 @@ -450,9 +531,7 @@ function tdcli_update_callback(data)
  				elseif (text:match("^(ارسال به) (.*)$") and msg.reply_to_message_id_ ~= 0) then
  					local matches = text:match("^ارسال به (.*)$")
  					local naji
 -					if matches:match("^(همه)$") then
 -						naji = "botBOT-IDall"
 -					elseif matches:match("^(خصوصی)") then
 +					if matches:match("^(خصوصی)") then
  						naji = "botBOT-IDusers"
  					elseif matches:match("^(گروه)$") then
  						naji = "botBOT-IDgroups"
 @@ -578,7 +657,7 @@ function tdcli_update_callback(data)
  						from_background_ = 1
  					}, dl_cb, nil)
  				elseif text:match("^(راهنما)$") then
 -					local txt = '📍راهنمای دستورات سین گر📍\n\nانلاین\n<i>اعلام وضعیت سین گر ✔️</i>\n<code>❤️ حتی اگر سین گر شما دچار محدودیت ارسال پیام شده باشد بایستی به این پیام پاسخ دهد❤️</code>\n/reload\n<i>l🔄 بارگذاری مجدد ربات 🔄l</i>\n<code>I⛔️عدم استفاده بی جهت⛔️I</code>\nبروزرسانی ربات\n<i>بروزرسانی ربات به آخرین نسخه و بارگذاری مجدد 🆕</i>\n\nافزودن مدیر شناسه\n<i>افزودن مدیر جدید با شناسه عددی داده شده 🛂</i>\n\nافزودن مدیرکل شناسه\n<i>افزودن مدیرکل جدید با شناسه عددی داده شده 🛂</i>\n\n<code>(⚠️ تفاوت مدیر و مدیر‌کل دسترسی به اعطا و یا گرفتن مقام مدیریت است⚠️)</code>\n\nحذف مدیر شناسه\n<i>حذف مدیر یا مدیرکل با شناسه عددی داده شده ✖️</i>\n\nترک گروه\n<i>خارج شدن از گروه و حذف آن از اطلاعات گروه ها 🏃</i>\n\nافزودن همه مخاطبین\n<i>افزودن حداکثر مخاطبین و افراد در گفت و گوهای شخصی به گروه ➕</i>\n\nشناسه من\n<i>دریافت شناسه خود 🆔</i>\n\nبگو متن\n<i>دریافت متن 🗣</i>\n\nارسال کن "شناسه" متن\n<i>ارسال متن به شناسه گروه یا کاربر داده شده 📤</i>\n\nتنظیم نام "نام" فامیل\n<i>تنظیم نام ربات ✏️</i>\n\nتازه سازی ربات\n<i>تازه‌سازی اطلاعات فردی ربات🎈</i>\n<code>(مورد استفاده در مواردی همچون پس از تنظیم نام📍جهت بروزکردن نام مخاطب اشتراکی سین‌گر📍)</code>\n\nتنظیم نام کاربری اسم\n<i>جایگزینی اسم با نام کاربری فعلی(محدود در بازه زمانی کوتاه) 🔄</i>\n\nحذف نام کاربری\n<i>حذف کردن نام کاربری ❎</i>\n\nافزودن با شماره روشن|خاموش\n<i>تغییر وضعیت اشتراک شماره تبلیغ‌گر در جواب شماره به اشتراک گذاشته شده 🔖</i>\n\nافزودن با پیام روشن|خاموش\n<i>تغییر وضعیت ارسال پیام در جواب شماره به اشتراک گذاشته شده ℹ️</i>\n\nتنظیم پیام افزودن مخاطب متن\n<i>تنظیم متن داده شده به عنوان جواب شماره به اشتراک گذاشته شده 📨</i>\n\nلیست مخاطبین|خصوصی|گروه|سوپرگروه|پاسخ های خودکار|لینک|مدیر\n<i>دریافت لیستی از مورد خواسته شده در قالب پرونده متنی یا پیام 📄</i>\n\nمسدودیت شناسه\n<i>مسدود‌کردن(بلاک) کاربر با شناسه داده شده از گفت و گوی خصوصی 🚫</i>\n\nرفع مسدودیت شناسه\n<i>رفع مسدودیت کاربر با شناسه داده شده 💢</i>\n\nوضعیت مشاهده روشن|خاموش 👁\n<i>تغییر وضعیت مشاهده پیام‌ها توسط سین‌گر (فعال و غیر‌فعال‌کردن تیک دوم)</i>\n\nامار\n<i>دریافت آمار و وضعیت سین گر 📊</i>\n\nوضعیت\n<i>دریافت وضعیت اجرایی تبلیغ‌گر⚙</i>\n\nتازه سازی\n<i>تازه‌سازی آمار سین‌گر🚀</i>\n<code>🎃مورد استفاده حداکثر یک بار در روز🎃</code>\n\nارسال به همه|خصوصی|گروه|سوپرگروه\n<i>ارسال پیام جواب داده شده به مورد خواسته شده 📩</i>\n<code>(😄توصیه ما عدم استفاده از همه و خصوصی😄)</code>\n\nارسال به سوپرگروه متن\n<i>ارسال متن داده شده به همه سوپرگروه ها ✉️</i>\n<code>(😜توصیه ما استفاده و ادغام دستورات بگو و ارسال به سوپرگروه😜)</code>\n\nتنظیم جواب "متن" جواب\n<i>تنظیم جوابی به عنوان پاسخ خودکار به پیام وارد شده مطابق با متن باشد 📝</i>\n\nحذف جواب متن\n<i>حذف جواب مربوط به متن ✖️</i>\n\nپاسخگوی خودکار روشن|خاموش\n<i>تغییر وضعیت پاسخگویی خودکار تبلیغ گر به متن های تنظیم شده 📯</i>\n\nافزودن به همه شناسه\n<i>افزودن کابر با شناسه وارد شده به همه گروه و سوپرگروه ها ➕➕</i>\n\nترک کردن شناسه\n<i>عملیات ترک کردن با استفاده از شناسه گروه 🏃</i>\n\nراهنما\n<i>دریافت همین پیام 🆘</i>\n〰〰〰ا〰〰〰\nهمگام سازی با تبچی\n<code>همگام سازی اطلاعات تبلیغ گر با اطلاعات سین گر از قبل نصب شده 🔃 (جهت این امر حتما به ویدیو آموزشی کانال مراجعه کنید)</code>\n〰〰〰ا〰〰〰\nسازنده : @ghool \nکانال : @sin_gar\n<i>آدرس سورس سین گر (کاملا فارسی) :</i>\nhttps://github.com/narimanpayande/SinGar\n<code>آخرین اخبار و رویداد های تبلیغ گر را در کانال ما پیگیری کنید.</code>'
 +					local txt = '📍راهنمای دستورات سین گر📍\n\nانلاین\n<i>اعلام وضعیت سین گر ✔️</i>\n<code>❤️ حتی اگر سین‌گر شما دچار محدودیت ارسال پیام شده باشد بایستی به این پیام پاسخ دهد❤️</code>\n/reload\n<i>l🔄 بارگذاری مجدد ربات 🔄l</i>\n<code>I⛔️عدم استفاده بی جهت⛔️I</code>\nبروزرسانی ربات\n<i>بروزرسانی ربات به آخرین نسخه و بارگذاری مجدد 🆕</i>\n\nافزودن مدیر شناسه\n<i>افزودن مدیر جدید با شناسه عددی داده شده 🛂</i>\n\nافزودن مدیرکل شناسه\n<i>افزودن مدیرکل جدید با شناسه عددی داده شده 🛂</i>\n\n<code>(⚠️ تفاوت مدیر و مدیر‌کل دسترسی به اعطا و یا گرفتن مقام مدیریت است⚠️)</code>\n\nحذف مدیر شناسه\n<i>حذف مدیر یا مدیرکل با شناسه عددی داده شده ✖️</i>\n\nترک گروه\n<i>خارج شدن از گروه و حذف آن از اطلاعات گروه ها 🏃</i>\n\nافزودن همه مخاطبین\n<i>افزودن حداکثر مخاطبین و افراد در گفت و گوهای شخصی به گروه ➕</i>\n\nشناسه من\n<i>دریافت شناسه خود 🆔</i>\n\nبگو متن\n<i>دریافت متن 🗣</i>\n\nارسال کن "شناسه" متن\n<i>ارسال متن به شناسه گروه یا کاربر داده شده 📤</i>\n\nتنظیم نام "نام" فامیل\n<i>تنظیم نام ربات ✏️</i>\n\nتازه سازی ربات\n<i>تازه‌سازی اطلاعات فردی ربات🎈</i>\n<code>(مورد استفاده در مواردی همچون پس از تنظیم نام📍جهت بروزکردن نام مخاطب اشتراکی سین گر📍)</code>\n\nتنظیم نام کاربری اسم\n<i>جایگزینی اسم با نام کاربری فعلی(محدود در بازه زمانی کوتاه) 🔄</i>\n\nحذف نام کاربری\n<i>حذف کردن نام کاربری ❎</i>\n\nتوقف عضویت|تایید لینک|شناسایی لینک|افزودن مخاطب\n<i>غیر‌فعال کردن فرایند خواسته شده</i> ◼️\n\nشروع عضویت|تایید لینک|شناسایی لینک|افزودن مخاطب\n<i>فعال‌سازی فرایند خواسته شده</i> ◻️\n\nافزودن با شماره روشن|خاموش\n<i>تغییر وضعیت اشتراک شماره سین‌گر در جواب شماره به اشتراک گذاشته شده 🔖</i>\n\nافزودن با پیام روشن|خاموش\n<i>تغییر وضعیت ارسال پیام در جواب شماره به اشتراک گذاشته شده ℹ️</i>\n\nتنظیم پیام افزودن مخاطب متن\n<i>تنظیم متن داده شده به عنوان جواب شماره به اشتراک گذاشته شده 📨</i>\n\nلیست مخاطبین|خصوصی|گروه|سوپرگروه|پاسخ های خودکار|لینک|مدیر\n<i>دریافت لیستی از مورد خواسته شده در قالب پرونده متنی یا پیام 📄</i>\n\nمسدودیت شناسه\n<i>مسدود‌کردن(بلاک) کاربر با شناسه داده شده از گفت و گوی خصوصی 🚫</i>\n\nرفع مسدودیت شناسه\n<i>رفع مسدودیت کاربر با شناسه داده شده 💢</i>\n\nوضعیت مشاهده روشن|خاموش 👁\n<i>تغییر وضعیت مشاهده پیام‌ها توسط سین‌گر (فعال و غیر‌فعال‌کردن تیک دوم)</i>\n\nامار\n<i>دریافت آمار و وضعیت سین‌گر 📊</i>\n\nوضعیت\n<i>دریافت وضعیت اجرای یسین‌گر⚙</i>\n\nتازه سازی\n<i>تازه‌سازی آمارسین‌گر🚀</i>\n<code>🎃مورد استفاده حداکثر یک بار در روز🎃</code>\n\nارسال به همه|خصوصی|گروه|سوپرگروه\n<i>ارسال پیام جواب داده شده به مورد خواسته شده 📩</i>\n<code>(😄توصیه ما عدم استفاده از همه و خصوصی😄)</code>\n\nارسال به سوپرگروه متن\n<i>ارسال متن داده شده به همه سوپرگروه ها ✉️</i>\n<code>(😜توصیه ما استفاده و ادغام دستورات بگو و ارسال به سوپرگروه😜)</code>\n\nتنظیم جواب "متن" جواب\n<i>تنظیم جوابی به عنوان پاسخ خودکار به پیام وارد شده مطابق با متن باشد 📝</i>\n\nحذف جواب متن\n<i>حذف جواب مربوط به متن ✖️</i>\n\nپاسخگوی خودکار روشن|خاموش\n<i>تغییر وضعیت پاسخگویی خودکار سین‌گر به متن های تنظیم شده 📯</i>\n\nحذف لینک عضویت|تایید|ذخیره شده\n<i>حذف لیست لینک‌های مورد نظر </i>❌\n\nحذف کلی لینک عضویت|تایید|ذخیره شده\n<i>حذف کلی لیست لینک‌های مورد نظر </i>💢\n🔺<code>پذیرفتن مجدد لینک در صورت حذف کلی</code>🔻\n\nافزودن به همه شناسه\n<i>افزودن کابر با شناسه وارد شده به همه گروه و سوپرگروه ها ➕➕</i>\n\nترک کردن شناسه\n<i>عملیات ترک کردن با استفاده از شناسه گروه 🏃</i>\n\nراهنما\n<i>دریافت همین پیام 🆘</i>\n〰〰〰ا〰〰〰\nهمگام سازی با سین گر\n<code>همگام سازی اطلاعات سین‌گر با اطلاعات سین گر از قبل نصب شده 🔃 (جهت این امر حتما به ویدیو آموزشی کانال مراجعه کنید)</code>\n〰〰〰ا〰〰〰\nسازنده : @ghool \nکانال : @sin_gar\n<i>آدرس سورس سین‌گر (کاملا فارسی) :</i>\nhttps://github.com/narimanpayande/SinGar\n<code>آخرین اخبار و رویداد های سین‌گر را در کانال ما پیگیری کنید.</code>'
  					return send(msg.chat_id_,msg.id_, txt)
  				elseif tostring(msg.chat_id_):match("^-") then
  					if text:match("^(ترک کردن)$") then
 @@ -625,7 +704,7 @@ function tdcli_update_callback(data)
  					end
  				end
  			end
 -		elseif msg.content_.ID == "MessageContact" then
 +		elseif (msg.content_.ID == "MessageContact" and redis:get("botBOT-IDsavecontacts")) then
  			local id = msg.content_.contact_.user_id_
  			if not redis:sismember("botBOT-IDaddedcontacts",id) then
  				redis:sadd("botBOT-IDaddedcontacts",id)
 @@ -673,16 +752,8 @@ function tdcli_update_callback(data)
  			end
  		elseif msg.content_.ID == "MessageChatDeleteMember" and msg.content_.id_ == bot_id then
  			return rem(msg.chat_id_)
 -		elseif msg.content_.ID == "MessageChatJoinByLink" and msg.sender_user_id_ == bot_id then
 -			return add(msg.chat_id_)
 -		elseif msg.content_.ID == "MessageChatAddMembers" then
 -			for i = 0, #msg.content_.members_ do
 -				if msg.content_.members_[i].id_ == bot_id then
 -					add(msg.chat_id_)
 -				end
 -			end
 -		elseif msg.content_.caption_ then
 -			return find_link(msg.content_.caption_)
 +		elseif (msg.content_.caption_ and redis:get("botBOT-IDlink"))then
 +			find_link(msg.content_.caption_)
  		end
  		if redis:get("botBOT-IDmarkread") then
  			tdcli_function ({
 @@ -696,7 +767,7 @@ function tdcli_update_callback(data)
  			ID = "GetChats",
  			offset_order_ = 9223372036854775807,
  			offset_chat_id_ = 0,
 -			limit_ = 20
 +			limit_ = 1000
  		}, dl_cb, nil)
  	end
  end
