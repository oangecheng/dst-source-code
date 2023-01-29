local STRINGS = GLOBAL.STRINGS


--Tất tật mọi thứ trong sách minh họa
STRINGS.MYTH_BOOINFO = {

    DUIHUAN = "Danh sách trao đổi",
    GEIYU = "Dâng lên",
    HUODE = "Nhận được",
    NOPLAYER = "Không tìm thấy danh sách nhân vật, vui lòng bật mod nhân vật để phục hồi",
    FILTER_ALL = "Tất cả",
    YONGJIU = "Vĩnh cửu",
    LONGER = "Rất lâu",
    HUOQU = "Công thức chế tạo",

    --Thần tiên
    SHENXIAN = {
        laozi = {
            title = "Đạo Đức Thiên Tôn, Thái Thượng Lão Quân\nĐốt Cấp Cấp Như Luật Lệnh để triệu hồi Lão Quân, có thể đưa nguyên liệu quý hoặc đạo cụ để đổi lấy đan dược hoặc pháp bảo. Số lượng trao đổi có hạn, sau mỗi lần triệu hồi phải chờ 3 ngày mới có thể triệu hồi lại.\nLão Quân không trao đổi với yêu nghiệt!",
        },
        ghg = {
            title = "Chủ nhân Quảng Hàn Cung, cư ngụ ngàn năm tại nguyệt cung. Nồng hậu chào đón khách nhân ghé thăm. Hằng Nga cần nghỉ ngơi ban đêm, chỉ tiếp khách ban ngày. Có thể tặng Hằng Nga các loại đá quý, hoặc Đại Bàn Đào để tăng hảo cảm, Hằng Nga cũng sẽ tặng lại bánh trung thu.",
        },
        tudi = {
            title = "Thổ Địa Công Công.\nThổ Địa Gia duy nhất. Xây miếu thổ địa và cúng kiếng đầy đủ, Thổ Địa sẽ xuất hiện chăm sóc và bảo vệ vườn, giúp vườn tược liên tiếp bội thu. Rất nhát gan và sẽ trốn mất khi có đánh nhau.\nThích nhặt các loại đá rơi vãi trên đất.",
            text1 = "Phạm vi chăm sóc",
            text2 = "Bán kính 4 ô\ntính từ miếu Thổ Địa",
            text3 = "Loại đồ cúng",
            text4 = "Một món mặn, một món chay, một món ăn nhẹ",
            text5 = "Thời gian hiện diện",
            text6 = "5 ngày sau khi cúng, Ban ngày và buổi chiều",
        },
        ylw = {
            title = "统领阴间十八层地狱的冥王。\n使用酆都路引召唤阎罗王虚影，阎罗王可以镇压范围内善恶魂的暴动，也可以交付善恶魂来回复三维。",
        },
        mp = {
            title = "掌管将生魂抹去记忆的阴使。\n使用酆都路引召唤孟婆虚影，孟婆会吸收范围内善恶魂，也可以给予孟婆善恶魂，孟婆收满一定数量的善恶魂后会留给玩家一碗忘却前世的茶汤—孟婆汤。",
        },
        cj = {
            title = "冥府阴律司判官。\n使用酆都路引召唤崔珏虚影，崔珏会吸收范围内善恶魂，也可以给予崔珏善恶魂，崔珏收到大量的善恶魂后会留给玩家一本掌控生死的鬼书—生死簿。",
        },
        lzd = {
            title = "冥府察查司判官。\n使用酆都路引召唤陆之道虚影，陆之道会对范围内吸进无常官帽的魂魄进行善与恶的转换，也可以交付魂魄进行善与恶的转换。",
        },
        zk = {
            title = "冥府罚恶司判官。\n使用酆都路引召唤钟馗虚影，钟馗可以镇压范围内恶魂的暴动，镇压后能够提供范围内的玩家三维回复，也可以交付恶魂来回复三维。",
        },
        wz = {
            title = "冥府赏善司判官。\n使用酆都路引召唤魏征虚影，魏征可以镇压范围内善魂的暴动，镇压后能够短暂提高范围内的玩家的攻击，也可以交付善魂来回复三维。",
        },
    },
    --Yêu quái
    YAOGUAI = {
        blackbearger = {
            title = "Hắc Phong Đại Vương.\nYêu tinh gấu đen ăn trộm cà sa, uy lực vô cùng. Nhấc tay có thể biến đất bằng thành núi, lại còn có thể biến thành cơn gió đen. Thích mật ong, cà sa, và đan dược, mang theo một bình hồ lô thuốc.",
            text1 = "Phương pháp triệu hồi",
            text2 = "Một cái bình sẽ được tạo ra gần Hang Đá,\ncó thể chứa mật ong hoặc Sữa Ong Chúa.\nHũ đầy mật ong sẽ dẫn dụ Hắc Phong Đại Vương xuất hiện",
            text3 = "Lưu ý",
            text4 = "Hắc Phong Đại Vương đánh rất đau và đòn đánh làm rơi\nvũ khí! Nếu rời khỏi chiến trường quá lâu,\nHắc Phong Đại Vương sẽ hóa thành cơn gió bay đi mất.\nTái xuất: 20 ngày",
            text5 = "Chiến lợi phẩm",
        },
        sxn = {
            title = "Tê Ngưu Tam Đại Vương.\nTích Hàn Tích Thử Tích Trần Tam Đại Vương, mỗi tết Nguyên Tiêu đều đi ăn trộm dầu đốt đèn khi mọi người bận xem hoa đăng. Đừng coi thường 3 anh em này. Đã đánh là không nương tay, đã pháp lực cao cường còn biết ỷ đông hiếp yếu.",
            text1 = "Phương pháp triệu hồi",
            text2 = "Trên Trúc Lâm xuất hiện ngẫu nhiên\ntrên bản đồ có thể tìm thấy một bàn\nthờ vỡ, dâng đào và đốt nến sẽ dẫn\ndụ được Tê Ngưu Tam Đại Vương",
            text3 = "Lưu ý",
            text4 = "Mỗi con tê giác giỏi một loại pháp thuật, có tư duy chiến thuật,\nbiết chia nhau đánh luân phiên, Dễ từ bỏ truy đuổi nếu thôi bị tấn công.\nTrong tình huống bất lợi sẽ chiến đấu cực kỳ khủng bố!\nNếu đối phương tháo chạy ra biển, Tam Đại Vương sẽ biến mất.\nTái xuất:Mùa xuân năm sau",
            text5 = "Chiến lợi phẩm",
        },
        myth_goldfrog = {
            title = "Tụ Bảo Kim Thiềm.\n sống trên mặt trăng, cả ngày trốn trong lòng đất bảo hộ kho báu vô tận của nó. Nghe nói nó có một cái Tụ Bảo Bồn và một cây Dao Tiền Thụ không ngừng sinh sản tiền tài.",
            text1 = "Phương pháp triệu hồi",
            text2 = "Trên mảnh đất phía ngoài Nguyệt Cung có\nmột đống vàng sáng lóa. Ai cả gan ăn\ntrộm vàng này sẽ nhận lấy cơn thịnh nộ\ncủa Tụ Bảo Kim Thiềm.",
            text3 = "Lưu ý",
            text4 = "Tụ Bảo Kim Thiềm da dày thịt cứng, dùng lượng lớn tiền tài\nhay gọi cả đàn Tiểu Kim Thiềm ra tấn công người chơi.\nKhi đối mặt với nhiều người, nó sẽ nuốt một người chơi\nvà bào mòn giáp của người đó. Nếu sơ hở nó sẽ chui\nxuống đất trốn mất.\nTái xuất:20 ngày",
            text5 = "Chiến lợi phẩm",
        },
        zgxn = {
            title = "Tử Khuê Huyền Điểu.\nCon Huyền Điểu này trời sinh đã phủ một lớp khoáng thạch có sinh mệnh, thích ăn hoa sen. Tương truyền nó là linh vật canh giữ một hòn đảo đầy khoáng thạch có sinh mệnh. Tiếng hót vang vọng, chỉ cần hót một tiếng cũng đủ khiến ác nhân buông đao",
            text1 = "Phương pháp triệu hồi",
            text2 = "Con chim quý cực kỳ khó thấy này thích\năn hoa sen nở rộ. Nếu có duyên sẽ thấy\nnó xuất hiện cạnh hồ sen nở.",
            text3 = "Lưu ý",
            text4 = "Tính cách ôn thuận, sau khi ăn xong hoa sen sẽ bay đi mất.\nChớ có chọc giận nó. Thời gian tái xuất sau khi giận： 10 ngày",
            text5 = "Quà tặng từ Huyền Điểu",
            text6 = "Tử Khuê Thạch là loại\nkhoáng thạch đặc biệt có sinh mệnh",
        },
        nian = {
            title = "传说中会带来灾厄的年兽，\n头长犄角，尖牙利齿，目光凶狠，\n生性残暴，长年深居海底，每到除夕会上岸\n入侵小镇，吞噬牲畜，伤人害命。",
            text1 = "生成方式",
            text2 = "在冬天倒数第二天的傍晚，\n灾厄年兽会入侵\n建有小市的青竹洲，\n出现在供台附近。\n",
            text3 = "注意事项",
            text4 = "年兽喜欢吞噬弱小的生物来滋补自己，\n会传染厄运使玩家变得虚弱，受伤严重时会进行自我回复，\n比较害怕鞭炮和火焰，进入春季便会离去。\n没有成功驱逐，青竹洲小市会丢失货物\n并停止进货五天(成功驱逐三犀牛会提前结束)。\n刷新时间：下一年冬天倒数第二天的傍晚",
            text5 = "战利品",     
            text6 = "小镇\n贺年", 
            text7 = "成功驱逐年兽，青竹洲小市打折五天，\n天黑不闭市至春季结束(三犀牛入侵会提前结束)。",     
        },
    },

    --Địa danh
    DIXING = {
        taoyuan = {
            title = "Đào Hoa Nguyên.\nTrên bản đồ sẽ xuất hiện ngẫu nhiên một hòn đảo biệt lập tên Đào Hoa Nguyên, trên mọc đầy Bàn Đào Thụ. Người chơi có thể hái Bàn Đào và sẽ có cơ hội nhỏ rơi ra Đại Bàn Đào, có thể gieo Đại Bàn Đào trên đất để trồng Bàn Đào Thụ. Bàn Đào Thụ có chu kỳ sinh trưởng dài, không thể thôi thúc, nhưng vẫn có thể phát triển trong mùa đông. Chặt Bàn Đào Thụ sẽ khiến Krampus xuất hiện. Diệt Krampus sẽ có xác suất rơi thêm Bàn Đào.",
            text1 = "Linh Đài Phương Thốn Sơn",
            text2 = "Tiên sơn cô độc ở thế ngoại đào viên. Nếu giải được cấm chế,\nđèn 4 góc sẽ sáng lên cho phép người chơi tiến vào\nthư phòng xưa của Bồ Đề Lão Tổ và học Đằng Vân Thuật.",
            text3 = "Bàn Đào Thụ",
            text4 = "Bàn Đào Thụ, thức ăn đặc biệt trên Đào Nguyên.\nHái Bàn Đào có xác suất rơi Đại Bàn Đào.\nPhá hoại rừng đào sẽ gặp chuyện không hay.",
        },
        yuegong = {
            title = "Nguyệt Lương Tinh Phiến là địa danh được tạo ra ngẫu nhiên ngoài rìa bản đồ. Nơi ấy tuyết rơi quanh năm, hàn khí lạnh lẽo vô cùng. Ở giữa Tinh Phiến có một cung điện nguy nga trang nhã. Trên nền đất lạnh bên ngoài còn có một bức tượng Kim Nguyên Bảo kỳ quái.",
            text1 = "Quảng Hàn Cung",
            text2 = "Nguyệt Cung nơi Hằng Nga Tiên Tử cư ngụ.\nBan ngày mới được phép vào.\nBuộc phải rời đi trước khi màn đêm buông xuống",
            text3 = "Kim Nguyên Bảo",
            text4 = "Tụ Bảo Kim Thiềm ngủ đông ở đây.\nNgười làm phiền sự nghỉ ngơi của Kim Thiềm sẽ bị phạt nặng.\nNếu cảm thấy bị đe dọa, Kim Thiềm sẽ không ứng chiến mà\nsẽ sủi mất. Cả tháng sau mới lại hiện thân.",
        },
        zhulin = {
            title = "Trúc Lâm.\nMột hòn đảo được trúc xanh bao phủ sẽ xuất hiện ngẫu nhiên trên mép bản đồ. Châu Tự Nhất Cốc Tiểu Trấn trên đảo có một nhóm cư dân hiền lành và tốt bụng sinh sống. Trên đảo còn một nơi từng dùng để thờ cúng tổ tiên, nay đã bị yêu quái chiếm làm đàn tế, bắt thôn dân mỗi năm vào mùa xuân phải cống nạp cầu an mới được bình yên.",
            text1 = "Hoa Sen",
            text2 = "Hoa Sen sinh trưởng trong ao, mọc vào mùa xuân, nở vào mùa thu, tàn vào mùa hạ, lụi vào mùa đông. Dùng dao cạo có thể thu hoạch thêm lá sen. Hoa sen nở sẽ thu hút Tử Khuê Huyền Điểu giáng thế, Tử Khuê Huyền Điểu sẽ nhả lại Tử Khuê Thạch tượng trưng cho lực lượng sinh mệnh. Dâng hoa sen cho Tử Khuê Huyền Điểu sẽ được bảo vệ bình an, có thể nhận thêm nhiều Tử Khuê Thạch. Chỉ nên đứng xem, không được trêu chọc.",
            text3 = "Bàn Thờ Đổ Nát",
            text4 = "Tê Ngưu Tam Đại Vương chiếm Thanh Trúc Châu thiết lập\nbàn tế, mỗi dịp Nguyên Tiêu phải cúng kiếng đầy đủ.\nTrong đêm xuân dâng Bàn Đào và thắp nến\nsẽ triệu tới Tê Ngưu Tam Đại Vương",
            text5 = "Cây Trúc",
            text6 = "生长在青竹洲的竹子修长挺拔，四季青翠，喜欢成片生长，在雨水充沛的春季繁殖速度极快，是极好的造纸材料。竹子有多个生长阶段，鲜嫩的竹笋可口美味，使用竹子烹饪的食物更是别有一番风味，成竹有可能会继续生长成坚硬苍竹。使用苍竹搭建房子是个不错的选择。",
            text7 = "Thanh Trúc Tiểu Trấn",
            text8 = "Tượng Người Bảo Hộ",
        },
        renshenguo = {
            title = "在算命小铺中购买的藏宝线索有可能寻得一颗被推倒的枯树根，被推倒的枯树根在井中经过玉净瓶中甘露水的滋润、日月精华的熏陶、玩家的悉心照料会长成参天的人参果树，人参果树每隔七七四十九天会长出传闻食用后可长生不老的人参果。",
            text1 = "人参果树",
            text2 = "高耸入云的人参果树提供大范围的树荫，树荫之下不怕风吹雨淋，不怕烈阳暴晒，不怕电闪雷鸣。结出的果子遇金而落，遇木而枯，遇水而化，遇火而焦，遇土而入。人参果树极难被破坏，唯火焰可烧毁之。",
        },
    },

    ITEM_TYPE = { --Loại hình
        renwu = "Nhân Vật",
        dixing = "Địa Danh",
        lianzhi = "Luyện Chế",
        shenhua = "Thần Thoại",
        shenxian = "Thần Tiên",
        yaoguai = "Yêu Quái",

        xiandan = "Tiên Đan",
        fabao = "Pháp Bảo",
        cailiao = "Nguyên Liệu",
        zhuangbei = "Trang Bị",
        jianzhu = "Kiến Trúc",
        gongju = "Công Cụ",
        shiwu = "Thực Phẩm",
        jineng = "Kỹ Năng",
        feixingshu = "Phép Đằng Vân",
    },

    ITEM_DES = {--物界面描述
        heat_resistant_pill = "Chống cháy, chống quá nhiệt!",
        cold_resistant_pill = "Chống ướt, chống lạnh, chống cóng!",
        dust_resistant_pill = "Chống bão cát!",
        fly_pill = "Tốc độ tăng lên nhanh như chớp!\nNgười thường uống vào có thể đằng vân",
        bloodthirsty_pill = "Cung cấp khả năng hút máu khủng bố, cẩn thận phản phệ!",
        armor_pill = "Cung cấp khả năng phòng ngự, giảm phân nửa sát thương!",
        condensed_pill = "Gia tăng chiến lực, lực công kích tăng gấp đôi!",
        thorns_pill = "Miễn nhiễm với sát thương từ thực vật!",
        movemountain_pill = "Đạt được thần lực, thân mang vật nặng vẫn bước như bay!",
        bananafan_big = "Âm dương tương hỗ, quạt một cái liền dập tắt lửa!",
        laozi_sp = "Đặt lá bùa trên đất rồi đốt để triệu hồi Lão Quân!",
        mk_huoyuan = "Nguyên liệu luyện chế Tỏa Tử Hoàng Kim Giáp",
        mk_longpi = "Nguyên liệu luyện chế Tỏa Tử Hoàng Kim Giáp",
        mk_hualing = "Nguyện liệu luyện chế Phụng Sí Tử Kim Quan",
        purple_gourd = "Hút hết vật phẩm và sinh vật nhỏ trong một vùng!",
        myth_yjp = "Chăm bón cho đất, thúc cây sinh sôi, hấp thu mưa!",
        myth_passcard_jie = "Yêu tinh cầm lệnh này có thể cùng Lão Quân giao dịch!",
        laozi_bell = "Chuông Thanh Ngưu được Thái Thượng Lão Quân chế tạo!",
        saddle_qingniu = "Yên Thanh Ngưu được Thái Thượng Lão Quân chế tạo!",
        myth_weapon_syf = "Tấn công gây đóng băng, có thể thi triển Hàn Băng Hoành Tảo!",
        myth_weapon_syd = "Càng đánh càng tăng sát thương, có thể thi triển Chích Nhiệt Trọng Trảm!",
        myth_weapon_gtt = "Tấn công cùng lúc nhiều mục tiêu, có thể thi triển Súc Lực Trọng Chùy",

        siving_stone = "Nguyên liệu chế tạo Tử Khuê trang bị!",
        myth_qxj = "Diệt sát Sinh Vật Ảo Ảnh nhưng không rơi đồ, có thể thi triển Nhất Xích Hàn Quang!",
        siving_hat = "Giảm sát thương, khôi phục tinh thần, làm chậm độ tiêu hao trang bị!",
        armorsiving = "Giảm sát thương, khôi phục tinh thần, dưới ánh mặt trời tự tăng độ bền!",
        myth_fuchen = "Tăng tốc di chuyển, hóa giải thù hận, có thể lấy vật từ xa!",

        yangjian_armor = "Ngăn cản 85% sát thương, tăng tốc di chuyển,\nchống thấm, chống lạnh hiệu quả",
        yangjian_hair = "Giảm tiêu hao khi dùng kỹ năng\nGiết quái vật tăng tinh thần!",
        golden_armor_mk = "Ngăn cản 85% sát thương, tăng 20% sát thương,\nChống hiệu ứng trúng đòn!",
        golden_hat_mk = "Giảm tiêu hao khi dùng kỹ năng\nGiết quái vật tăng tinh thần!",

        book_myth = "Sách thần thoại phương đông, không có nội dung gì. Châm lửa đốt sẽ khiến nội dung hiện ra!",
        alchmy_fur = "Dùng đúng nguyên liệu có thể luyện chế, dùng sai hậu quả khôn lường!",
        myth_cash_tree_ground = "Tài bảo cuồn cuộn, mỗi 2 ngày rơi xuống một phần tiền tài!",
        cassock = "Khôi phục tinh thần, giảm nhu cầu ăn uống!",
        kam_lan_cassock = "Chống lại Sinh Vật Ảo Ảnh, khôi phục nhiều tinh thần, giảm nhu cầu ăn uống!",
        mk_battle_flag = "Tăng lực công kích. Tăng tốc di chuyển, khôi phục tinh thần!",
        xzhat_mk = "Giữ ấm, khôi phục tinh thần!",
        pill_bottle_gourd = "Có thể đựng 8 loại đan dược, đan dược trong hồ lô không bị hao mòn!",
        wine_bottle_gourd = "Trực tiếp uống để phục hồi tinh thần, có thể đổ thêm Bàn Đào Tửu vào cho đầy!",
        myth_zongzi = "Có thể cầm trong tay, ném xuống biển sẽ hấp dẫn cá, cũng có thể mở ra ăn!",
        myth_redlantern = "Chiếu sáng nhẹ nhàng, có thể cầm trong tay, cũng có thể treo lên giá!",
        myth_bbn = "Hấp thu năng lượng đêm trăng tròn có thể mở ra không gian 9 ô!",
        myth_fence = "Bình phong đẹp mắt!",
        myth_interiors_ghg_flower = "Bình hoa xinh đẹp!",
        myth_interiors_ghg_groundlight = "Cung đăng xinh đẹp, còn có thể chiếu sáng!",
        myth_interiors_ghg_he_left = "Tượng tiên hạc trang nhã!",
        myth_interiors_ghg_he_right = "Tượng tiên hạc trang nhã!",
        myth_interiors_ghg_lu = "Lư hương thanh tĩnh!",
        myth_redlantern_ground = "Có thể Treo 2 đèn lồng!",
        myth_ruyi = "Hái Bàn Đào dễ dàng, tăng tỷ lệ rơi Đại Bàn Đào!",
        myth_yylp = "Đứng gần có thể mở Thẻ Thiên Tinh, ban đêm chiếu sáng, chỉ có một cái, không thể đem xuống hang!",
        myth_mooncake_ice = "Khóa điểm tinh thần trong một ngày, không thể ăn nhồi!",
        myth_mooncake_lotus = "Giải trừ tác hại của thức ăn trong một ngày, không thể ăn nhồi!",
        myth_mooncake_nuts = "Khóa điểm no trong một ngày, không thể ăn nhồi!",

        lotus_flower = "Có thể đem nấu ăn hay sửa chữa Hỗn Thiên Lăng!",
        lotus_seeds = "Có thể đem nấu ăn, ăn trực tiếp, hoặc gieo xuống hồ sẽ mọc cây sen!",
        lotus_seeds_cooked = "Có thể đem nấu ăn, hoặc ăn trực tiếp",
        lotus_root = "Có thể ăn trực tiếp hoặc dùng để nấu ăn!",
        lotus_root_cooked = "Có thể ăn trực tiếp hoặc dùng để nấu ăn!",
        myth_lotusleaf = "Có thể đem nấu ăn, hoặc cầm trong tay như dù!",

        myth_bamboo = "Nguyên liệu chế tạo, cũng là nguyên liệu nấu ăn!",
        myth_greenbamboo = "Nguyên liệu quý giá!",
        myth_bamboo_shoots = "Có thể đem nấu ăn, hoặc trồng trên đất thành cây trúc!",
        myth_bamboo_shoots_cooked = "Có thể trực tiếp ăn hoặc đem đi nấu ăn",
        bigpeach = "Ngon không chịu nổi!",
        peach = "Có thể trực tiếp ăn, đem đi nấu ăn, hoặc nướng trong lửa!",
        peach_cooked = "Có thể trực tiếp ăn, hoặc đem đi nấu ăn!",
        gourd = "Cây rau, thích hợp sinh trưởng mùa thu!",
        gourd_cooked = "Có thể trực tiếp ăn, hoặc đem đi nấu ăn!",
        myth_banana_leaf = "Có thể chế tạo giấy gói lá chuối, là nguyên liệu nấu ăn!",
        myth_bundle = "Gói lá chuối!",
        myth_cash_tree = "Nguyên liệu trồng Dao Tiền Thụ, chỉ có một cây!",
        myth_coin = "Có thể dùng để thử vận may ở Tụ Bảo Bồn!",
        myth_food_table = "Có thể trưng bày 8 đĩa thức ăn khác nhau, độ tươi vĩnh cửu!",
        myth_granary = "Cất trữ rau và hạt trong thời gian dài, dễ cháy!",
        myth_toy = "Có thể trưng bày trên đất, hoặc đổi với Vua Lợn lấy Kim Nguyên Bảo!",
        myth_tudi_shrines = "Dâng cũng chay mặn nhẹ 3 món sẽ thỉnh được Thổ Địa về phù hộ 5 ngày!",
        myth_well = "Mùa đông không đóng băng, không có cá, dập được đám khói, có thể múc nước!",
        myth_banana_tree = "Có thể thu hoạch Lá chuối và Quả chuối",
        bananafan = "Nguyên liệu luyện chế Ba Tiêu Bảo Phiến, hô mưa gọi gió!",
        myth_rhino_blueheart = "Nguyên liệu luyện chế Tị Thử Đan, Sương Việt Phủ!",
        myth_rhino_redheart = "Nguyên liệu luyện chế Tị Hàn Đan, Thử Tập Đao!",
        myth_rhino_yellowheart = "Nguyên liệu luyện chế Tị Trần Đan, Cột Thát Đằng!",
        siving_rocks = "Nguyên liệu luyện chế Tử Khuê Thanh Kim!",
        krampussack_sealed = "Nguyên liệu luyện chế Tử Kim Hồng Hồ Lô!",
        myth_huanhundan = "Thân thể ăn vào có thể triệu hồi linh hồn xuất khiếu về nhập vào thân xác!",
        myth_coin_box = "Một xâu tiền lớn!",
        myth_mooncake_box = "Một hộp bánh trung thu ngon lành!",

        myth_flyskill = "Đằng vân lên nào, cẩn thận kẻo ngã!",

        myth_flyskill_mk = "Ta lộn một vòng bay được mười vạn tám nghìn dặm!",
        mk_dsf = "Đóng băng toàn bộ nhưng sinh vật đang phẫn nộ trên màn hình!",
        mk_jgb = "Vũ khí riêng của Tôn Ngộ Không, khoảng cách tấn công lớn, có thể dùng kỹ năng Thân Ngoại Thân Pháp!",

        nz_lance = "Vũ khí riêng của Na Tra, gây sát thương cao hơn với hỏa thuộc tính, có thẻ dùng kỹ năng Ba Đầu Sáu Tay!",
        nz_ring = "Vũ khí riêng của Na  Tra, tấn công từ xa, tấn công nhiều mục tiêu!",
        nz_damask = "Trang bị riêng của Na Tra, tăng tốc di chuyển, miễn dịch thương tổn, dùng hoa sen để bổ sung độ bền!",
        myth_flyskill_nz = "Hỏa diểm dưới chân chói lóa, đạp trên ngọn lửa!",

        bone_blade = "Tấn công tự hút máu, dùng Mảnh Xương để sửa chữa!",
        bone_wand = "Tạo ra gai xương khống chế và sát thương đối thủ, dùng Mảnh Xương để sửa chữa!",
        bone_whip = "Sát thương diện rộng, hút máu, dùng Mảnh Xương để sửa chữa!",
        wb_heart = "Bạch Cốt Phu Nhân nuốt tim sẽ biến thành trạng thái hồn ma, lưu lại Hài Cốt!",
        myth_flyskill_wb = "Nấp giữa âm phong, không bị phát hiện, không bị công kích!",

        pigsy_hat = "Giữ ấm, tăng lực phòng ngự, che mưa, khôi phục tinh thần!",
        pigsy_rake = "Vũ khí riêng của Bát Giới, có thể dùng để đỡ đòn, cũng có thể dùng để cày ruộng!",
        pigsy_sleepbed = "Ổ rơm của Bát Giới, ngủ lúc nào cũng được, tiêu hao no để khôi phục máu và tinh thần!",
        myth_flyskill_pg = "Mềm nhũn tiết kiệm sức, chẳng phải lo đói bụng!",
        myth_pigsyskill_bookinfo = "Biến hình giúp hồi máu, tăng cao phòng ngự,\ncó thể thu hút kẻ thủ, có thể bơi dưới biển!",

        yj_spear = "Vũ khí riêng của Dương Tiễn, triệu hồi lôi điện, có thể thi triển Khu Lôi Xiết Điện!",
        myth_flyskill_yj = "Lôi điện vây quanh người, chạm vào người ta tất chịu đau khổ!",
        yangjian_track = "Có thể trực tiếp bay tới điểm đánh dấu hoặc đồng đội!",

        medicine_pestle_myth = "Vũ khí riêng của Thỏ Ngọc, có thể dùng để giã thuốc!",
        guitar_jadehare = "Sau khi học cầm phổ, chơi đàn sẽ tạo ra nốt nhạc,\nngười chơi có thể bắt nốt nhạc để lấy kích hoạt",
        myth_bamboo_basket = "Trong giỏ đầy cây thuốc!",
        myth_flyskill_yt = "Đám mây lạnh lẽo, hương thuốc tan ra thấm cả vào ruột gan!",

        bone_mirror = "Thay đổi áo choàng, đạt năng lực mới!",

        --白骨披风
        wb_armorbone = "Hy sinh khả năng hút máu để lấy khả năng phòng ngự!",
        wb_armorblood = "Khả năng hút máu tăng mạnh!",
        wb_armorlight = "Nhẹ nhàng như gió,\ntăng cao tốc độ di chuyển!",
        wb_armorgreed = "Tăng xác suất rơi vật phẩm\ntăng thời gian xác tồn tại",
        wb_armorstorage = "Thêm 8 ô vật phẩm,\ntự động nhặt vật phẩm đã có sẵn trong tay áo",
        wb_armorfog = "Trong sương mù các năng lực đều tăng lên, đồng thời Cốt Nhận có thêm kỹ năng Vụ Ẩn",

        hat_commissioner_white = "Đội lên có thể hấp thu thiện ác hồn,\nchống ướt 20%",
        bell_commissioner = "Dùng 1 thiện hồn ru ngủ sinh vật chung quanh\nsau khi tỉnh lại tốc độ di chuyển và tấn công cũng bị giảm",
        token_commissioner= "Dùng 1 ác hồn dọa sinh vật chung quanh hoảng sợ",
        pennant_commissioner= "Dùng 3 thiện hồn gọi 3 ân hồn về chiến đấu",
        whip_commissioner= "Càng mang nhiều ác hồn, lực đánh càng cao, tốc độ đánh càng thấp",
        soul_specter= "Âm hồn thiện lương\nbỏ không sẽ ru ngủ phụ cận",
        soul_ghast= "Âm hồn tà ác\nbỏ không sẽ biến thành Oán hồn quậy phá!",
        myth_yama_statue1 = "Dâng hồn phách khôi phục ba thông số, giảm thời gian hút hồn\ncấp càng cao lực càng mạnh, ngược lại hiệu quả đồ ăn càng giảm",
        myth_cqf = "Sử dụng khiến hồn lìa khỏi xác,\nrơi vào trạng thái linh hồn xuất khiếu",
        myth_higanbana_item = "Có đồng đội chết sẽ nở rộ,\nsử dụng sẽ cho phép hồn ma đồng đội dịch chuyển đến bên cạnh",
        myth_bahy = "Hoa bỉ ngạn nở,\nhồi sinh hồn ma người chơi chung quanh",

        myth_flyskill_ya = "Ma trơi quẩn quanh, di hình đổi ảnh,\nkhông thể tấn công hoặc bị tấn công",

        powder_m_becomestar = "较长时间的发光，玉兔捣药为群体效果，\n给予嫦娥发光浆果解锁配方！",
        powder_m_charged = "短时间攻击带电，玉兔捣药为群体效果，\n给予嫦娥电羊角解锁配方！",
        powder_m_coldeye = "短时间攻击附带冰冻，玉兔捣药为群体效果，\n给予嫦娥巨鹿眼球解锁配方！",
        powder_m_hypnoticherb = "回复大量血量且催眠周围生物，\n玉兔捣药为群体效果，\n给予嫦娥曼德拉草解锁配方！",
        powder_m_improvehealth = "回复部分血量后且短时间缓慢回血，\n玉兔捣药为群体效果，\n给予嫦娥蜂王浆解锁配方！",
        powder_m_lifeelixir = "满状态复活队友，玉兔捣药为群体复活，\n给予嫦娥守护者之角解锁配方！",
        powder_m_takeiteasy = "回复部分精神后且短时间缓慢回复精神，\n玉兔捣药为群体效果，\n给予嫦娥舒缓茶解锁配方！",

        song_m_workup = "弹奏产生buff音符，\n拾取音符后工作效率暂时提升",
        song_m_insomnia = "弹奏产生buff音符，\n拾取音符后暂时不会被催眠！",
        song_m_fireimmune = "弹奏产生buff音符，\n拾取音符后暂时免疫火焰伤害！",
        song_m_iceimmune = "弹奏产生buff音符，\n拾取音符后暂时免疫冰冻封印！",
        song_m_iceshield = "弹奏产生buff音符，拾取音符后\n短时间内受到攻击时可使敌人叠加冰冻！",
        song_m_nocure = "弹奏使附近敌人暂时失去自愈能力！",
        song_m_weakattack = "弹奏使附近敌人的攻击力暂时降低！",
        song_m_weakdefense = "弹奏使附近敌人的防御力暂时降低！",
        song_m_nolove = "弹奏使附近牛群暂时不会发情！",
        song_m_sweetdream = "弹奏使附近敌人进入睡眠！",

        madameweb_stinger = "一次性的远程武器！",
        madameweb_poisonstinger = "淬上致命毒素的蜂针！",
        madameweb_armor = "减少蛛丝值的消耗，拥有2格专属物品格子，\n可保暖，可使用蛛丝回复耐久！",
        madameweb_poisonbeemine = "每日孕育一毒蛛，可用肉召唤毒蛛出来，\n也可将毒蛛放回巢中休养！",
        madameweb_beemine = "触发后会毒蜂攻击敌人！",
        madameweb_detoxify = "解除中毒状态！",
        madameweb_net = "可以安置在地上，会往外扩张蛛网地皮！",
        madameweb_pitfall = "将靠近的生物束缚成茧，茧破裂后会使生物中毒！",
        madameweb_feisheng = "适合在地洞以及树荫下穿梭！",
        madameweb_silkcocoon = "打包萤火虫悬挂于树荫和地洞照明！",
        hua_internet_node_item = "放置地上变成盘丝标点,\n使用蛛丝连接标点进行滑行！",
        hua_internet_node_sea_item = "放置海上变成盘丝标点,\n使用蛛丝连接标点进行滑行！",
        hua_fake_spider_shoe = "携带即可在盘丝滑索上滑行，\n快速行走于蛛网之上",

        myth_stool = "坐在小凳子上休息会！",
        myth_coldessense = "培育人参果树的材料！",
        myth_fireessense = "培育人参果树的材料！",
        nian_bell = "喂饱后摇响铃铛可召唤年兽坐骑！",
        cane_peach = "提高移动速度，右键【弃杖化林】\n可化作小片桃林！",
        myth_gold_staff = "用于采摘人参果和蟠桃，\n也会提高大蟠桃掉率！",
        myth_nianhat = "七成防御，进食有概率\n不消耗食物且获得双倍收益！",
        infantree_carpet = "华丽的人参果地毯！",
        wall_dwelling_item = "古朴的白墙黑瓦！",
        fence_bamboo_item = "精美的竹制栅栏！",
        fence_gate_bamboo_item = "精美的竹制门！",
        myth_rocktips = "在地上摆上精致的鹅卵石装饰！",
        myth_nian_fur = "制造年兽面具的材料！",
        myth_iron_broadsword = "精铁铸造的长刀，拥有51点伤害！",
        myth_iron_battlegear = "精铁铸造的甲胄，拥有八成的防御！",
        myth_iron_helmet = "精铁铸造的头盔，拥有八成的防御！",
        myth_house_bamboo = "古色古香的竹林瓦屋！",
        miniflare_myth = "绚丽的烟花增添一些年味儿！",
        firecrackers_myth = "燃放爆竹增添一些年味儿，\n还可以协助驱逐灾厄年兽！",
        myth_infant_fruit = "食用后获得生命持续回复至生命少于三分之一，\n遇金而落，遇木而枯，遇水而化，遇火而焦，遇土而入！",
        pass_commissioner = "传信接引地府神仙的虚影！",
        commissioner_mpt = "饮用后身化彼岸花直接原地转世重生，\n重生时物品将保留在彼岸花中！",
        commissioner_book = "查询全体玩家的状态并选择复活逝去玩家，\n也可复活残存魂魄虚影的生物！",



    },

    ITEM_RECIPE_DES = { --物品获取方式/配方描述
        myth_yylp = "Được Hằng Nga tặng khi đạt hảo cảm tối đa!",
        myth_mooncake = "Tặng Hằng Nga đá quý hay Đại Bàn Đào sẽ có cơ hội nhận",

        lotus_flower = "Na Tra tước thịt mà thành, hoặc ngắt sen nở ngoài hồ!",
        lotus_seeds = "Mở cánh hoa sen, thu hoạch hạt sen!",
        lotus_seeds_cooked = "Nướng hạt sen trên lửa!",
        lotus_root = "Hái sen khi sen đã chín!",
        lotus_root_cooked = "Nướng củ sen trên đống lửa!",
        myth_lotusleaf = "Dùng Dao Cạo hái sen nở ngoài hồ!",

        myth_bamboo = "Chặt cây trúc để thu hoạch!",
        myth_greenbamboo = "Chặt cây thương trúc có thể thu hoạch!",
        myth_bamboo_shoots = "Sau cơn mưa gần cây trúc có thể mọc măng, đào để thu hoạch!",
        myth_bamboo_shoots_cooked = "Nướng măng trên lửa!",
        bigpeach = "Hái đào có cơ hội rơi xuống, giết Klaus cũng có cơ hội nhận được!",
        peach = "Hái đào để thu hoạch, giết Krampus có cơ hội rơi ra!",
        peach_cooked = "Nướng Bàn Đào trên lửa!",
        gourd = "Gieo mầm có cơ hội sinh ra, mở túi Klaus có cơ hội nhận được!",
        gourd_cooked = "Nướng Hồ Lô trên lửa!",
        myth_banana_leaf = "Hái chuối để thu hoạch, mở Gói Lá Chuối cũng nhận được 1 Lá Chuối",
        myth_cash_tree = "Lần đầu đánh thắng Tụ Bảo Kim Thiềm đạt được!",
        myth_coin = "Đổi đồ chơi với Vua Heo, đánh yêu quái, hoặc nhặt từ Dao Tiền Thụ!",
        myth_toy = "Giao dịch với thổ địa, hoặc bỏ tiền vào Tụ Bảo Bồn có cơ hội rơi ra!",
        bananafan = "Đổi Quạt Cao Cấp với Thái Thượng Lão Quân",
        myth_rhino_blueheart = "Giết Tích Hàn Đại Vương rơi ra!",
        myth_rhino_redheart = "Giết Tích Thử Đại Vương rơi ra!",
        myth_rhino_yellowheart = "Giết Tích Trần Đại Vương rơi ra!",
        siving_rocks = "Tử Khuê Huyền Điểu ăn hoa sen sẽ để lại, cho Tử Khuê Huyền Điểu ăn hoa sen cũng được nhận lại!",
        krampussack_sealed = "Dùng Cấp Cấp Như Luật Lệnh phong ấn túi Krampus!",
        myth_coin_box = "Xâu 40 đồng tiền lại bằng sợi dây thừng!",

        myth_huanhundan = "Trao đổi Tim Mách Lẻo với Thái Thượng Lão Quân\nĐổi đồ ở Tụ Bảo Bồn có xác suất nhận được",
        soul_specter= "Sinh vật trung lập chết rơi ra",
        soul_ghast= "Sinh vật tà ác hoặc yêu quái chết rơi ra",

        mk_jgb = "Vật dụng khởi điểm của Ngộ Không",
        nz_zhuangbei_recipe = "Vật dụng khởi điểm của Na Tra", --哪吒三武器同一获取方式描述
        pigsy_rake = "vật dụng khởi điểm của Bát Giới",
        yj_spear = "Vật dụng khởi điểm của Dương Tiễn",
        medicine_pestle_myth = "Vật dụng khởi điểm của Thỏ Ngọc",
        hat_commissioner_white = "Vật dụng khởi điểm của Hắc Bạch Vô Thường",
        zhuangbei_commissioner_w = "Vật dụng khởi điểm của Bạch Vô Thường",
        zhuangbei_commissioner_b= "Vật dụng khởi điểm của Hắc Vô Thường",


        wb_armorfog = "Tự động nhận được khi nâng Bạch Cốt Yêu Kính lên cấp cuối!",
        fcs_learn = "Học đằng vân để kích hoạt",

        song_m_workup = "给予嫦娥仙子蜂王冠可学会该曲谱！",
        song_m_insomnia = "给予嫦娥仙子独奏乐器可学会该曲谱！",
        song_m_fireimmune = "给予嫦娥仙子龙鳞皮可学会该曲谱！",
        song_m_iceimmune = "给予嫦娥仙子滚烫的热石可学会该曲谱！",
        song_m_iceshield = "给予嫦娥仙子冰鲷鱼可学会该曲谱！",
        song_m_nocure = "给予嫦娥仙子蜘蛛卵可学会该曲谱！",
        song_m_weakattack = "给予嫦娥仙子羽毛扇可学会该曲谱！",
        song_m_weakdefense = "给予嫦娥仙子熊皮可学会该曲谱！",
        song_m_nolove = "给予嫦娥仙子牛角帽可学会该曲谱！",
        song_m_sweetdream = "给予嫦娥仙子排箫可学会该曲谱！",

        myth_coldessense = "使用紫金葫芦单独吸取极光获得！",
        myth_fireessense = "使用紫金葫芦单独吸取矮星获得！",
        nian_bell = "首次成功驱逐年兽获得！",
        cane_peach = "聚宝盆有几率获得\n在桃源也能获得一根！",
        myth_nian_fur = "灾厄年兽掉落！",
        pandaman_rareitem_sale = "珍奇小铺出售！",
        pandaman_weapons_sale = "铸匠小铺出售！",
        myth_infant_fruit = "使用金击子采摘获得！",
        commissioner_mpt = "孟婆虚影收善恶魂各20个获得！",
        commissioner_book = "崔珏虚影收善恶魂各99个获得！",


	},

    ITEM_TIME = {
        tian = " ngày",
        naijiuzhi = " độ bền",
        mk = "Tôn Ngộ Không",
        nz = "Na Tra",
        bg = "Bạch Cốt Phu Nhân",
        bj = "Trư Bát Giới",
        yj = "Dương Tiễn",
        yt = "Ngọc Thố",
        hb = "Hắc Bạch Vô Thường",
        hwc = "Hắc Vô Thường",
        bwc = "Bạch Vô Thường",
        etc = "Các nhân vật khác",
        melody = "琵琶曲",
        zzj = "盘丝娘娘",


    },

    ITEM_SKIN = {--皮肤
        monkey_king1 = "Xuất Hải Học Nghệ",
        monkey_king2 = "Hỏa Nhãn Kim Tinh",
        monkey_king3 = "Hí Trung Hành Giả",
        monkey_king4 = "Lục Nhĩ Mi Hầu",
        monkey_king5 = "Bật Mã Ôn",
        monkey_king6 = "白面醉翁",

        neza1 = "Thanh Liên Bạch Ngẫu",
        neza2 = "Thánh Anh Đại Vương",
        neza3 = "Trì Anh Thiếu Niên",
        neza4 = "风火唱将",

        white_bone1 = "Lê Viên Họa Bì",
        white_bone2 = "西凉女王",

        pigsy1 = "Bát Giới Đón Dâu",
        pigsy2 = "Bạch Nha Lão Tượng",
        pigsy3 = "室火星宿",

        yangjian1 = "Mặc Ảnh Tố Tấn",
        yangjian2 = "Diệu Đạo Thanh Nguyên",
        yangjian3 = "Lưu Kim Hổ Tướng",
        yangjian4 = "金翅大鹏",

        yutu1 = "Thiềm Cung Ngọc Thiện",
        yutu2 = "Hàn Nguyệt Noãn Đông",
        yutu3 = "Hạnh Hoa Tiên Tử",
        yutu4 = "月桂酒香",
        yutu5 = "悦耳甜音",

        yama1 = "莲花洞主",

        madameweb1 = "烛香白鼠",

        myth_he_left = "Tả Tiên Hạc",
        myth_he_right = "Hữu Tiên Hạc",

        bone_mirror1 = "Yêu Kính Cấp 1",
        bone_mirror2 = "Yêu Kính Cấp 2",
        bone_mirror3 = "Yêu Kính Cấp Tối Đa",

        myth_yama_statue1 = "Pho Tượng Diêm La",
        myth_yama_statue2 = "Tượng Thờ Diêm La",
        myth_yama_statue3 = "Miếu Thờ Diêm La",
        myth_yama_statue4 = "Đền Thờ Diêm Vương",

        myth_redlantern_ground1 = "枯枝",

        myth_stool1 = "七星",
        myth_stool2 = "墨玉",
        myth_stool3 = "玄冥",
        myth_stool4 = "卧熊",
        myth_stool5 = "虎啸",
        myth_stool6 = "凤台",

		mk_battle_flag1 = "燎原",

		myth_food_table1 = "七星",
        myth_food_table2 = "墨玉",

    },

    ITEM_XIAOGUO = {
        naijiu = "Độ bền",
        suoshu = "Tương ứng",
        yaoxiao = "Hiệu quả",
        xiaoguo = "Tác dụng",
        lztime = "Luyện chế",
        peifang = "Công thức",
    },
}




--------------------------------------------------------------------------
--[[ 杂七杂八 ]]
--------------------------------------------------------------------------
STRINGS.NAMES.MYTH_DOOR_EXIT = "Cửa"
STRINGS.NAMES.MYTH_DOOR_EXIT_1 = "Cửa"
STRINGS.NAMES.MYTH_DOOR_EXIT_2 = "Cửa"
STRINGS.NAMES.MYTH_DOOR_EXIT_3 = "Cửa"

STRINGS.NAMES.MYTH_DOOR_ENTER = "Cửa lớn"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_DOOR_ENTER = "Linh Đài Phương Thốn, thả khứ tìm tâm"

STRINGS.NAMES.MYTH_SMALLLIGHT = "Đèn đá"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_SMALLLIGHT = "Mở được phép cấm, bốn bên lên đèn"

STRINGS.MYTH_WEIGHDOWN = "Nhấn xuống"

STRINGS.READ_FLY_BOOK = "Đọc"
STRINGS.MYTH_CLEAR = "Lau chùi"
STRINGS.MYTHNOFLYINROOM = "Trong phòng không thể đằng vân!"

STRINGS.OLDMYTH_INTERIORS = "Bụi bám trên "

STRINGS.NAMES.BOOK_FLY_MYTH = "Sách"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_FLY_MYTH = "Vô Tự Thiên Thư sót lại."

STRINGS.NAMES.MYTH_INTERIORS_LIGHT = "Ngọn đèn"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_LIGHT = "Chỉ là một ngọn đèn dầu thông thường."

STRINGS.NAMES.MYTH_INTERIORS_BED = "Trường Kỷ"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_BED = "Thổi hơi trà, ngồi luận đạo."

STRINGS.NAMES.MYTH_INTERIORS_GZ = "Bình gốm"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GZ = "Bình với chả lọ"

STRINGS.NAMES.MYTH_INTERIORS_GH = "Bức họa"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GH = "Hồng Mông Sơ Tích Bản Vô Tính, Đả Phá Gian Ngoan Tu Ngộ Không"

STRINGS.NAMES.MYTH_INTERIORS_GH_SMALL = "Bức Họa"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GH_SMALL = "Tâm"

STRINGS.NAMES.MYTH_INTERIORS_PF = "Bình Phong"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_PF = "Chất liệu không tầm thường."

STRINGS.NAMES.MYTH_INTERIORS_XL = "Lư Hương"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_XL = "Bỏ vào hương liệu đặc chế là có thể đốt lên."

STRINGS.NAMES.MYTH_INTERIORS_ZZ = "Bàn"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_ZZ = "Một quyển sách và vài ống quyển đang viết dang dở nằm trên bàn"

--新加食物
STRINGS.NAMES.MYTH_FOOD_ZPD = "Rau câu da lợn"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_ZPD = "Nhìn thôi là đã chóng cả mặt"

STRINGS.NAMES.MYTH_FOOD_NX = "Kem Chuối"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_NX = "Ăn vào bữa trà là lý tưởng nhất"

STRINGS.NAMES.MYTH_FOOD_LXQ = "Tôm Viên Lá Chuối"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_LXQ = "Nguyên liệu nấu ăn xịn thì chỉ cần phương pháp nấu đơn giản nhất..."

STRINGS.NAMES.MYTH_FOOD_FHY = "Tôm Hoa Sen"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_FHY = "Món ăn quý và lạ nhất thế gian"

STRINGS.NAMES.MYTH_FOOD_HYMZ = "Chén Trăng Hoa"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_HYMZ = "Ta không nhẫn tâm ăn nó!"

STRINGS.NAMES.MYTH_BANANA_LEAF = "Lá chuối"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_BANANA_LEAF = "Lá chuối to thật!"

STRINGS.NAMES.MYTH_BUNDLE = "Giấy gói lá chuối"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_BUNDLE = "Gói bằng lá chuối"

STRINGS.NAMES.MYTH_BUNDLEWRAP = "Gói lá chuối"
STRINGS.RECIPE_DESC.MYTH_BUNDLEWRAP = "Gói đồ của bạn bằng lá chuối"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_BUNDLEWRAP = "Gói lấy một ít đồ vật bên trong."

STRINGS.NAMES.MYTH_BANANA_TREE = "Cây Chuối"
STRINGS.RECIPE_DESC.MYTH_BANANA_TREE = "Dùng ma pháp để trồng một cây chuối"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_BANANA_TREE = "So với bản dưới hang thì bản này tốt hơn."

STRINGS.NAMES.MYTH_ZONGZI1 = "Bánh ú nhân ngọt"
STRINGS.RECIPE_DESC.MYTH_ZONGZI1 = "Làm một cái bánh ngọt"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_ZONGZI1 = "gạo nếp trắng thêm táo đỏ, trông như tương mã não"

STRINGS.NAMES.MYTH_ZONGZI2 = "Bánh ú nhân mặn"
STRINGS.RECIPE_DESC.MYTH_ZONGZI2 = "Làm một cái bánh mặn"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_ZONGZI2 = "Vị hơi mặn mặn, mùi khá nhẹ nhàng."

STRINGS.NAMES.MYTH_ZONGZI_ITEM1 = "Bánh ú nhân ngọt"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_ZONGZI_ITEM1 = "Vị ngọt ngào ngon miệng, trông lại xinh xắn"

STRINGS.NAMES.MYTH_ZONGZI_ITEM2 = "Bánh ú nhân mặn"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_ZONGZI_ITEM2 = "Vị mặn gây thèm, muốn mở ăn ngay"

STRINGS.NAMES.BANANAFAN_BIG = "Ba Tiêu Bảo Phiến"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BANANAFAN_BIG = "Báu vật này thật không tầm thường!"

STRINGS.NAMES.MYTH_FLYSKILL = "Bạch Vân"
STRINGS.RECIPE_DESC.MYTH_FLYSKILL = "Bí thuật cổ phương đông."

STRINGS.NAMES.MYTH_FLYSKILL_MK = "Cân Đẩu Vân"
STRINGS.RECIPE_DESC.MYTH_FLYSKILL_MK = "Lộn một vòng đi xa vạn dặm."

STRINGS.NAMES.MYTH_FLYSKILL_NZ = "Phong Hỏa Luân"
STRINGS.RECIPE_DESC.MYTH_FLYSKILL_NZ = "Trở mình đi nghìn dặm, nháy mắt tới Cửu Châu."

STRINGS.NAMES.MYTH_FLYSKILL_WB = "Âm Phong"
STRINGS.RECIPE_DESC.MYTH_FLYSKILL_WB = "Gió âm bốn bề, khó tìm tung tích."

STRINGS.NAMES.MYTH_FLYSKILL_PG = "Miên Hoa Vân"
STRINGS.RECIPE_DESC.MYTH_FLYSKILL_PG = "Mềm nhun nhũn, chắc thình thịch."

STRINGS.NAMES.MYTH_FLYSKILL_YJ = "Lôi Vân"
STRINGS.RECIPE_DESC.MYTH_FLYSKILL_YJ = "Tới lui như sấm, bay vút ngang trời."

STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.FUR_COOK ={
	INUSE = 'Có người khác đang dùng.',
}

STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.NZ_PLANT={
	HASONE = "Không thể đặt vào.",
}

STRINGS.NAMES.HEAT_RESISTANT_PILL = "Tị Thử Đan"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEAT_RESISTANT_PILL = "Giữ đan này ta cảm thấy khói lửa không bén trời nắng không lo!"

STRINGS.NAMES.COLD_RESISTANT_PILL = "Tị Hàn Đan"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.COLD_RESISTANT_PILL = "Ta không sợ lạnh, mưa gió không làm gì được ta!"

STRINGS.NAMES.DUST_RESISTANT_PILL = "Tị Trần Đan"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DUST_RESISTANT_PILL = "Không cần lo lắng bụi trần chướng mắt!"

STRINGS.NAMES.FLY_PILL = "Đằng Vân Đan"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FLY_PILL = "Thật sao? Ta đầng vân được rồi!"

STRINGS.NAMES.BLOODTHIRSTY_PILL = "Thị Huyết Đan"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BLOODTHIRSTY_PILL = "Trông thật giống con dơi!"

STRINGS.NAMES.CONDENSED_PILL = "Ngưng Vị Đan"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CONDENSED_PILL = "Uống đan này khiến ta không thể không tập trung tinh thần!"

STRINGS.NAMES.PEACH = "Bàn Đào"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACH = "Quả đào này thật không tầm thường."
STRINGS.NAMES.PEACH_COOKED = "Bàn Đào nướng"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACH_COOKED = "Nướng chín lại trở thành bình thường rồi."
STRINGS.NAMES.PEACH_BANQUET = "Bàn Đào Đại Hội"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACH_BANQUET = "Phần hoa quả đơn sơ này lại nhờ một quả đào ngon lành khó cưỡng."
STRINGS.NAMES.PEACH_WINE = "Bàn Đào Tửu"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACH_WINE = "Rượu hoa quả này thật khác biệt."

STRINGS.NAMES.MK_BATTLE_FLAG = "Chiến Kỳ"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MK_BATTLE_FLAG = "Đây là một lá chiến kỳ, còn có thể viết chữ lên!"
STRINGS.NAMES.MK_BATTLE_FLAG_ITEM = "Chiến Kỳ"
STRINGS.RECIPE_DESC.MK_BATTLE_FLAG_ITEM = "Cắm cờ trên đất tăng sĩ khí."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MK_BATTLE_FLAG_ITEM = "Đây là một lá chiến kỳ, còn có thể viết chữ lên!"

STRINGS.NAMES.HONEY_PIE = "Bánh Mật Ong"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HONEY_PIE = "Thức ăn đơn giản, thêm ít mật ong."

STRINGS.NAMES.VEGETARIAN_FOOD = "Cơm Chay"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.VEGETARIAN_FOOD = "Hương vị thật thanh đạm!"

STRINGS.NAMES.CASSOCK = "Cà Sa"
STRINGS.RECIPE_DESC.CASSOCK = "Mặc trên người tách biệt phàm trần"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CASSOCK = "Mô phật! Bần tăng là kẻ tu hành."

STRINGS.NAMES.KAM_LAN_CASSOCK = "Kim Lĩnh Cà Sa"
STRINGS.RECIPE_DESC.KAM_LAN_CASSOCK = "Khoác lên người yêu ma tránh xa."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KAM_LAN_CASSOCK = "Cái cà sa này hào quang thật rực rỡ!"

STRINGS.NAMES.GOLDEN_HAT_MK = "Phụng Sí Tử Kim Quán"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOLDEN_HAT_MK = "Hay cho cái mũ lẫm liệt uy phong!"

STRINGS.NAMES.GOLDEN_ARMOR_MK = "Tỏa Tử Hoàng Kim Giáp"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOLDEN_ARMOR_MK = "Bộ giáp bách chiến bách thắng!"

STRINGS.NAMES.XZHAT_MK = "Hành Giả Mão"
STRINGS.RECIPE_DESC.XZHAT_MK = "Thẳng hướng trời tây làm hành giả."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.XZHAT_MK = "Mũ này đội thật dễ chịu!"

STRINGS.NAMES.BIGPEACH = "Đại Bàn Đào"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BIGPEACH = "Quả này so với mấy quả kia thì to hơn hẳn!"

STRINGS.NAMES.MK_HUALING = "Lông Công"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MK_HUALING = "Cái lông dài đẹp ghê!"

STRINGS.NAMES.MK_HUOYUAN = "Tim Đá Hỏa Viên"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MK_HUOYUAN = "Quả tim đá cầm vào phỏng tay!"

STRINGS.NAMES.MK_LONGPI = "Lụa Vảy Rồng"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MK_LONGPI = "Lụa gì động vào nóng rực!"

STRINGS.NAMES.LOTUS_FLOWER = "Hoa Sen"
STRINGS.RECIPE_DESC.LOTUS_FLOWER = "Lóc thịt trả mẹ, lóc xương trả cha"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LOTUS_FLOWER = "Một đóa hoa xinh đẹp."

STRINGS.NAMES.LOTUS_FLOWER_COOKED ="Hoa sen nướng"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LOTUS_FLOWER_COOKED = "Mày điên à mà hoa sen cũng đem đi nướng?"

STRINGS.NAMES.GOURD = "Hồ Lô"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOURD = "Một loại rau ngon lành."

STRINGS.NAMES.GOURD_COOKED = "Nồ Lô Nướng"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOURD_COOKED = "Nướng lên mùi thơm nức mũi"

STRINGS.NAMES.GOURD_SEEDS = "Hạt Hồ Lô"

STRINGS.NAMES.GOURD_SOUP = "Canh Hồ Lô"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOURD_SOUP = "Ngon vl!"

STRINGS.NAMES.GOURD_OMELET = "Hồ Lô Cuộn Trứng"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOURD_OMELET = "Bữa sáng ngon lành"

STRINGS.NAMES.PILL_BOTTLE_GOURD = "Đan Dược Hồ Lô"
STRINGS.RECIPE_DESC.PILL_BOTTLE_GOURD = "Đem đan dược cất giữ trong hồ lô."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PILL_BOTTLE_GOURD = "Cái này để cất đan dược."

STRINGS.NAMES.WINE_BOTTLE_GOURD = "Tửu Hồ Lô"
STRINGS.RECIPE_DESC.WINE_BOTTLE_GOURD = "Hồ lô đẹp, rượu ngon!"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WINE_BOTTLE_GOURD = "Ta ngửi thấy hơi rượu."

STRINGS.NAMES.THORNS_PILL = "Kinh Cức Đan"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.THORNS_PILL = "Bụi gai hộ giá!"

STRINGS.NAMES.ARMOR_PILL = "Tráng Cốt Đan"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMOR_PILL = "Cường thân kiện thể!"

STRINGS.NAMES.DETOXIC_PILL = "Hóa Độc Đan"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DETOXIC_PILL = "Giải được thế gian bách độc"

STRINGS.NAMES.LAOZI_SP = "Cấp Cấp Như Luật Lệnh"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAOZI_SP = "Thái Thượng Lão Quân, mau mau nghe lệnh ta!"

STRINGS.NAMES.LAOZI = "Thái Thượng Lão Quân"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAOZI = "Đây là ông thần của phương đông!"

STRINGS.NAMES.BANANAFAN = "Ba Tiêu Phiến"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BANANAFAN = "Màu sắc thật sặc sỡ!"

STRINGS.NAMES.ALCHMY_FUR = "Lò Bát Quái"
STRINGS.RECIPE_DESC.ALCHMY_FUR = "Chỉ lò này giữ được tam muội chân hỏa"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ALCHMY_FUR =  {
	EMPTY = "Đây là lò luyện đan trong truyền thuyết phương đông?",
	GENERIC = "Trời má! Nóng cháy cả da, nóng sạm cả tóc, nóng kinh hồn, nóng tàn bạo!",
	DONE = "Cái lò này luyện chế không có miếng logic nào cả?!",
}

STRINGS.MKRECIPE = "Thần Thoại"

STRINGS.LAOZI = {
    A = "Ngươi đang giỡn mặt ta sao...",
    B = "Hỗn xược!",
    C = "Chớ có làm càn!",
    D = "không được tham sân vô độ!",
    E = 'Yêu tinh thì đi chỗ khác chơi',
    F = "Ta viết Đạo Đức Kinh để lại Hàm Cốc, ngươi theo tu tập cần chuyên tâm",
}

STRINGS.NAMES.PEACHSPROUT_MYTH = "Mầm Cây Bàn Đào"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACHSPROUT_MYTH = "Mong là mau lớn!"

STRINGS.NAMES.PEACHSAPLING_MYTH = "Cây Bàn Đào Non"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACHSAPLING_MYTH = "Mong là mau chín!"

STRINGS.NAMES.PEACHSTUMP_MYTH = "Gốc Bàn Đào"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACHSTUMP_MYTH = "Thật đáng tiếc!"

STRINGS.NAMES.PEACHTREEBURNT_MYTH = "Cây Bàn Đào Cháy"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACHTREEBURNT_MYTH = "Đã hư hại hoàn toàn."

STRINGS.NAMES.PEACHTREE_MYTH = "Bàn Đào Thụ"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PEACHTREE_MYTH = {
    GENERIC = "Cây thần này ba nghìn năm ra hoa một lần, lại ba nghìn năm mới kết quả một lần!",
    BURNING = "Đừng đốt! Đừng đốt cây quý thế này!",
    BLOOM = "Để thấy cảnh này, ta đã đợi ba nghìn năm!",
    FRUIT = "Ta cô đơn đã hai triệu năm, cũng chỉ để chờ khoảnh khắc này."
}
STRINGS.CHARACTERS.WENDY.DESCRIBE.PEACHTREE_MYTH = {
    GENERIC = "Ở thôn đào có am hoa, trong am một vị tiên hoa thuở nào",
    BURNING = "Người cười ta kẻ điên khùng, ta cười người đấy người chừng hiểu chăng?",
    BLOOM = "Tiên hoa trồng cội hoa đào, lại đem hoa hái đổi bầu rượu thơm",
    FRUIT = "Tỉnh say ngày lại qua ngày, hoa tàn hoa nở năm tày nối năm"
}

STRINGS.NAMES.FANGCUNHILL = "Linh Đài Phương Thốn Sơn"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FANGCUNHILL = "Cửa động đóng chặt."

STRINGS.NAMES.BOOK_MYTH = "Vô Tự Thiên Thư"
STRINGS.RECIPE_DESC.BOOK_MYTH = "Một quyển sách kỳ lạ không có chữ"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_MYTH = "Mọi điều thông tuệ, đều tại không lời"
STRINGS.NAMES.BOOK_MYTH_YJ = "Vô Tự Thiên Thư"
STRINGS.RECIPE_DESC.BOOK_MYTH_YJ = "Một quyển sách kỳ lạ không cớ chữ"

STRINGS.NAMES.PURPLE_GOURD = "Tử Kim Hồng Hồ Lô"
STRINGS.NAMES.PURPLE_GOURD_MALE = "Tử Kim Hồng Hồ Lô - Hùng"
STRINGS.NAMES.PURPLE_GOURD_FEMALE = "Tử Kim Hồng Hồ Lô - Thư"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PURPLE_GOURD = "Bảo vật này có hào quang chói mắt!"

GLOBAL.Myth_AddCachedStr(
        function()
            --蟠桃树芽
            STRINGS.CHARACTERS.MONKEY_KING.DESCRIBE.PEACHSPROUT_MYTH = "Mầm cây này rất đáng để lão Tôn chiếu cố."
            STRINGS.CHARACTERS.NEZA.DESCRIBE.PEACHSPROUT_MYTH = "Cây này mới nảy mầm mà đã tỏa ra tiên khí tràn ngập."
            STRINGS.CHARACTERS.WHITE_BONE.DESCRIBE.PEACHSPROUT_MYTH = "Phế phẩm."
            STRINGS.CHARACTERS.PIGSY.DESCRIBE.PEACHSPROUT_MYTH = "Phải chờ bao lâu mới có quả ăn đây?"

            --蟠桃树苗
            STRINGS.CHARACTERS.MONKEY_KING.DESCRIBE.PEACHSAPLING_MYTH = "Lớn nhanh lớn nhanh, để Tôn gia gia nếm thử chút vị."
            STRINGS.CHARACTERS.NEZA.DESCRIBE.PEACHSAPLING_MYTH = "Thảo mộc ra hoa xuân, cây cối ra hoa hạ."
            STRINGS.CHARACTERS.WHITE_BONE.DESCRIBE.PEACHSAPLING_MYTH = "Đợi tiên thụ ra hoa kết quả rồi mới hủy nó không phải sẽ đẹp mắt lắm sao."
            STRINGS.CHARACTERS.PIGSY.DESCRIBE.PEACHSAPLING_MYTH = "Mọc gì chậm quá, bón thêm ít nước tiểu được không?"

            --蟠桃树桩
            STRINGS.CHARACTERS.MONKEY_KING.DESCRIBE.PEACHSTUMP_MYTH = "Đáng tiếc đáng tiếc!"
            STRINGS.CHARACTERS.NEZA.DESCRIBE.PEACHSTUMP_MYTH = "Yêu nghiệt phương nào gây nên? Vương Mẫu biết được chắc chắn sẽ rất tức giận!"
            STRINGS.CHARACTERS.WHITE_BONE.DESCRIBE.PEACHSTUMP_MYTH = "Nhổ cỏ phải nhổ tận gốc, không chừa hậu hoạn."
            STRINGS.CHARACTERS.PIGSY.DESCRIBE.PEACHSTUMP_MYTH = "Cái này không phải ta làm đâu, Hầu Ca ngươi phải tin ta."

            --烧焦的蟠桃树
            STRINGS.CHARACTERS.MONKEY_KING.DESCRIBE.PEACHTREEBURNT_MYTH = "Trời ơi là trời! Hoa Quả Sơn của ta!"
            STRINGS.CHARACTERS.NEZA.DESCRIBE.PEACHTREEBURNT_MYTH = "Dù là tiên thụ, cũng là mộc tính."
            STRINGS.CHARACTERS.WHITE_BONE.DESCRIBE.PEACHTREEBURNT_MYTH = "Chưa từng có được, nên không thấy mất mát gì."
            STRINGS.CHARACTERS.PIGSY.DESCRIBE.PEACHTREEBURNT_MYTH = "Hơ hơ, tiên thụ thì tiên thụ, gặp lửa cũng toang."

            --蟠桃树
            STRINGS.CHARACTERS.MONKEY_KING.DESCRIBE.PEACHTREE_MYTH = {
                GENERIC = "Thổ Địa nói cây này ba nghìn năm mới ra hoa, lại ba nghìn năm mới kết quả.",
                BURNING = "Chời! Chơi mà đốt cây thì ai chơi lại!",
                BLOOM = "Ha, màu đỏ tươi như cái mông của ta!",
                FRUIT = "Lão Tôn nhất định phải nếm thử mùi vị tiên đào này."
            }
            STRINGS.CHARACTERS.NEZA.DESCRIBE.PEACHTREE_MYTH = {
                GENERIC = "Cây tiên Dao Trì, sao lại xuất hiện ở nhân gian?",
                BURNING = "Hỏa Đức Tinh Quân sao nhẫn tâm thế này?",
                BLOOM = "Lò đan vừa nổi lửa, tiên đào đã nhuộm hồng.",
                FRUIT = "Trên tiệc Bàn Đào được ăn có vài quả, không như lần này nhiều đến phát thèm"
            }
            STRINGS.CHARACTERS.WHITE_BONE.DESCRIBE.PEACHTREE_MYTH = {
                GENERIC = "Cây này sinh ở Dao Trì, loài yêu quái cũng chỉ được nghe, hôm nay ta mới tận mắt thấy",
                BURNING = "Lòng ta thật vui!",
                BLOOM = "Đúng lúc son phấn của ta vừa hết.",
                FRUIT = "Hủy diệt cây này, nhất định sẽ chọc con khỉ chết toi kia tức điên."
            }
            STRINGS.CHARACTERS.PIGSY.DESCRIBE.PEACHTREE_MYTH = {
                GENERIC = "Ta với cây này giống nhau, bất đắc dĩ mới lọt vào đây.",
                BURNING = "Ái chà chà, ta không có nhẫn tâm được vậy đâu!",
                BLOOM = "Ta đi ngủ một lúc, tỉnh dậy có khi có đào ăn.",
                FRUIT = "Ơ hơ hơ, ta vặt trộm vài quả, anh khỉ chắc không biết được đâu."
            }

            --灵台方寸山
            STRINGS.CHARACTERS.MONKEY_KING.DESCRIBE.FANGCUNHILL = "Bảy năm có lẻ, một đạo trường sinh."
            STRINGS.CHARACTERS.NEZA.DESCRIBE.FANGCUNHILL = "Không biết cao nhân nào cư ngụ ở đây."
            STRINGS.CHARACTERS.WHITE_BONE.DESCRIBE.FANGCUNHILL = "Tiên phủ mờ ảo, cơ duyên chưa tới."
            STRINGS.CHARACTERS.PIGSY.DESCRIBE.FANGCUNHILL = "Ơ.. quả đào kia trong ngon mắt quá."
            STRINGS.CHARACTERS.YANGJIAN.DESCRIBE.FANGCUNHILL = "Nơi này đem so với Chi Đào Sơn thì thế nào?"

            --无字天书
            STRINGS.CHARACTERS.MONKEY_KING.DESCRIBE.BOOK_MYTH = "Sách gì rách nát, không thuận mắt ta. Mang đi mang đi."
            STRINGS.CHARACTERS.NEZA.DESCRIBE.BOOK_MYTH = "Vô Tự Thiên Thư không phải đang ở chỗ Khương Sư Thúc sao?"
            STRINGS.CHARACTERS.WHITE_BONE.DESCRIBE.BOOK_MYTH = "Đạo bất khả danh."
            STRINGS.CHARACTERS.PIGSY.DESCRIBE.BOOK_MYTH = "Có chữ hay không, ta cũng không biết nữa."
            STRINGS.CHARACTERS.YANGJIAN.DESCRIBE.BOOK_MYTH = "Trò trẻ con này, sao qua được mắt ta?"

            --紫金葫芦
            STRINGS.CHARACTERS.MONKEY_KING.DESCRIBE.PURPLE_GOURD = "Haha, ngươi đoán xem đây là hồ lô đực hay là hồ lô cái?"
            STRINGS.CHARACTERS.NEZA.DESCRIBE.PURPLE_GOURD = "Hồ Lô báu của sư bá tổ đựng đan dược đây mà."
            STRINGS.CHARACTERS.WHITE_BONE.DESCRIBE.PURPLE_GOURD = "Uống được một viên tiên đan, đỡ được nghìn năm khổ tu."
            STRINGS.CHARACTERS.PIGSY.DESCRIBE.PURPLE_GOURD = "Để ta xem bên trong có gì ngon không."
            STRINGS.CHARACTERS.YANGJIAN.DESCRIBE.PURPLE_GOURD = "Tay nắm hồ lô, càn khôn thâu tóm"
        end
)

--以前的内容集成
STRINGS.FUR_HARVEST = "Thu hoạch"
STRINGS.FUR_COOK = "Luyện chế"
STRINGS.MYTH_USE_INVENTORY = "Sử dụng"
STRINGS.USE_GOURD = "Uống"
STRINGS.RHI_PLACEITEM = "Nơi bày cống phẩm"
STRINGS.MYTH_RED_GIVE = "Treo đèn lồng"
STRINGS.MYTH_RED_TACK = "Lấy đèn lồng"
STRINGS.MKFLYLAND = "Đáp xuống"
STRINGS.NAMES.MYTH_RHINO_DESK = "Bàn thờ đổ nát"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_RHINO_DESK = "Tôi có cần thành tâm khấn vái không？"

------------------------月宫系列
STRINGS.MKCERECIPE = "Quà của Nguyệt Cung"

----嫦娥说的话
STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.MYTH_ENTER_HOUSE = {
    BANNED = "Vậy đó, bị dỗi rồi thì thôi vài ngày nữa hẵng quay lại đây vậy.",
    FLY = "Đang đằng vân ai cho vào nhà!",
    NOTIME = "Không biết làm sao để vào!" --白天不可以进
}

--[[
STRINGS.CHARACTERS.MONKEY_KING.ACTIONFAIL.MYTH_ENTER_HOUSE ={
	BANNED = "还是等几天再来吧",
	FLY = "飞行时候不能这么做!",
	NOTIME = "我不能这么做!", --白天不可以进
}
STRINGS.CHARACTERS.NEZA.ACTIONFAIL.MYTH_ENTER_HOUSE.BANNED = {
	BANNED = "还是等嫦娥姐姐消气了再去吧",
	FLY = "飞行时候不能这么做!",
	NOTIME = "我不能这么做!", --白天不可以进
}
STRINGS.CHARACTERS.YANGJIAN.ACTIONFAIL.MYTH_ENTER_HOUSE.BANNED = {
	BANNED = "仙子莫要生气了，杨戬改日再来",
	FLY = "飞行时候不能这么做!",
	NOTIME = "我不能这么做!", --白天不可以进
}
STRINGS.CHARACTERS.PIGSY.ACTIONFAIL.MYTH_ENTER_HOUSE.BANNED = {
	BANNED = "俺这糊涂脑子，啥事都能搞砸",
	FLY = "飞行时候不能这么做!",
	NOTIME = "我不能这么做!", --白天不可以进
}
STRINGS.CHARACTERS.WHITE_BONE.ACTIONFAIL.MYTH_ENTER_HOUSE.BANNED = {
	BANNED = "白骨失礼，望仙子海涵",
	FLY = "飞行时候不能这么做!",
	NOTIME = "我不能这么做!", --白天不可以进
}
]]
STRINGS.MYTHGHG_ISNIGHT = {
    --被赶出
    MONKEY_KING = "Hỏng bét! Lão Tôn tự nhiên quên giờ mất.",
    NEZA = "Không ổn, hình như Na Tra làm Hằng Nga tỷ tỷ tức giận rồi.",
    WHITE_BONE = "Thế gian rộng lớn, ta lại không chốn dung thân.",
    PIGSY = "Hôm nay ta lại say rượu làm loạn nữa ư?",
    YANGJIAN = "Ta đành tạ tội tiên tử khi khác vậy.",
    GENERIC = "Mình lẽ ra không nên vô lễ như vậy."
}

STRINGS.MYTHCEHAOGANDU = {
    --好感度 20 50 100 150
    [2] = {
        MONKEY_KING = "Đại Thánh khách sáo rồi.",
        NEZA = "Tam Thái Tử khách sáo  rồi.",
        WHITE_BONE = "Lòng tốt này ta xin nhận.",
        PIGSY = "Nguyên Soái khách sáo rồi.",
        YANGJIAN = "Chân Quân khách sáo rồi.",
        MYTH_YUTU = "Cảm ơn lễ vật của ngươi.",
        GENERIC = "Ngươi thật là khách sáo."
    },
    [4] = {
        MONKEY_KING = "Đa tạ Đại Thánh.",
        NEZA = "Đa tạ Thái tử.",
        WHITE_BONE = "Ngươi không cần làm vậy đâu.",
        PIGSY = "Không biết Thiên Bồng muốn nhờ việc gì?",
        YANGJIAN = "Chân quân có việc gì cần ta hỗ trợ?",
        MYTH_YUTU = "Chút lòng thành của ngươi lại khiến ta rất hài lòng.",
        GENERIC = "Đa tạ lễ vật của ngươi."
    },
    [6] = {
        MONKEY_KING = "Đại Thánh làm ta thật ngại quá.",
        NEZA = "Có thời gian khi khác lại đến chơi.",
        WHITE_BONE = "Nếu gặp chuyện xấu cứ đến chỗ ta lánh nạn.",
        PIGSY = "Chuyện cũ đã qua, nguyên soái không nên để trong lòng.",
        YANGJIAN = "Thì ra Chân Quân không lạnh lùng như đồn đại.",
        MYTH_YUTU = "Được rồi, hôm nay ngươi không phải giã thuốc nữa.",
        GENERIC = "Ngươi không cần khách sáo như vậy."
    },
    [7] = {
        MONKEY_KING = "Có vài cái bánh, xin tặng Đại Thánh trên đường Tây Du",
        NEZA = "Tấm lòng của Na Tra thật ngạt ngào hương sen",
        WHITE_BONE = "Ngày càng hướng thiện, nghĩ chuyện đã qua, sẽ tránh tai họa",
        PIGSY = "Mong Nguyên Soái sớm thành chánh quả, phục hồi chức vị",
        YANGJIAN = "Nếu có việc cần, Hằng Nga nhất định sẽ hỗ trợ",
        MYTH_YUTU = "Bên ngoài gặp chuyện đừng hoảng sợ, ta sẽ chu toàn giúp ngươi",
        GENERIC = "Duyên giữa ta và ngươi, có lẽ cũng không ít"
    }
}

STRINGS.MYTHGHG_NOCURRENTITEM = {
    --物品不对
    MONKEY_KING = "Đại Thánh xin đừng đùa giỡn.",
    NEZA = "Món này thì thôi Tam Thái Tử cứ giữ đi.",
    WHITE_BONE = "Ngươi làm càn gì thì ta cũng không dám động vào ngươi đâu.",
    PIGSY = "Nguyên Soái xin tự trọng.",
    YANGJIAN = "Chân Quân tới là để đem ta ra làm trò đùa?",
    MYTH_YUTU = "Haha, ta nhận tấm lòng.",
    GENERIC = "Ngươi xem ta là ăn mày bên đường sao?"
}

--问候
STRINGS.MYTHGHG_RCWH = {
    MONKEY_KING = {
        "Đại Thánh sao không bảo hộ sư phụ đi thỉnh kinh?",
        "Đại Thánh năm đó đại náo thiên cung quả là một đoạn truyền kỳ",
        "Chút điểm tâm của ta sao có thể sánh ngang Dao Trì Bàn Đào",
    },
    NEZA = {
        "Bánh trung thu này nếu thích thì mang về ăn đi",
        "Thái Ất xem ra rất thương ngươi, lại ban cho nhiều pháp bảo như vậy",
        "Ăn chậm một chút, uống ngụm trà cho trôi nào",
    },
    WHITE_BONE = {
        "Thiện ác có báo, chưa đến lúc thôi",
        "Mong ngươi làm nhiều việc thiện, lấy công đức bù đắp nghiệp chướng",
        "Đại đạo hữu tình, lẽ nào lại không cho ngươi một tia sinh cơ",
        "Ngươi thì ghê rồi",
    },
    PIGSY = {
        "Nguyên Soái bị giáng làm phàm nhân, sao lại đầu thai thành heo?",
        "Rượu làm hỏng việc, đừng uống nhiều.",
        "Đừng khách sáo, nếm chút đồ ăn đi.",
    },
    YANGJIAN = {
        "Chân Quân tới đây lẽ nào là muốn tâm sự?",
        "Một chút trà thô, tán gẫu cho người trải lòng",
        "Sao lông Hao Thiên bây giờ lại mượt như vậy? Haha.",
    },
    MYTH_YUTU = {
        "Nào kể ta nghe hôm nay bên ngoài gặp cái gì?",
        "Thuốc hôm nay đã chuẩn bị xong, đừng lười.",
        "Xuống đây chơi không có gì vui vẻ thì thôi theo ta về thiên cung đi.",
    },
    GENERIC = {
        "Mời nếm chút trà, trà của ta không giống trà của các ngươi",
        "Trông như ngươi đói, đừng ngại nếm chút bánh trung thu",
        "Gặp được nơi đây chính là duyên",
    }
}

--见面
STRINGS.MYTHGHG_JMWH = {
    MONKEY_KING = "Không biết Đại Thánh giáng lâm nên không từ xa nghênh đón, mời nhấp ngụm trà",
    NEZA = "Na Tra Thái Tử, lệnh tôn dạo này thế nào?",
    WHITE_BONE = "Ngươi tới Quảng Hàn Cung của ta cũng không tránh nổi tam tai lục họa, thôi vậy thôi vậy, ngồi xuống uống ngụm trà đi",
    PIGSY = "Thiên Bồng Nguyên Soái, đã lâu không gặp, dạo này ngài thế nào?",
    YANGJIAN = "Chân Quân chấp chưởng vạn quân, công việc bận rộn sao lại rảnh rỗi ghé chơi?",
    MYTH_YUTU = "Đứa trẻ ham chơi này, mấy hôm nay ngươi đã đi chơi ở đâu?",
    GENERIC = "Bằng hữu từ phương xa tới, xin mời vào chơi"
}

--嫦娥
STRINGS.MKCETALK_TOLEAVE = "Trời đã về chiều, chư vị cũng nên ra về thôi." --时间到了
STRINGS.MKCETALK_TOMANYPEOLE = "Quảng Hàn Cung đã lâu không náo nhiệt thế này!" --人多

STRINGS.SIT_ON_MYTH = "Ngồi xuống" --坐在垫子上

--玉兔重做tip：玉兔给予嫦娥道具触发的台词
STRINGS.MKCETALK_YUTU = {
    POWDER_M_HYPNOTICHERB = { --草参药粉
        GENERIC = "Loại thảo dược này chính là cực phẩm, ngươi phải suy nghĩ kỹ trước khi nghiền", --教玉兔时
        LEARNED = "Thảo dược quý hiếm, không có nhiều vậy dâu", --玉兔已经学过了
        WRONGSTATE = nil, --没有达到特殊条件
    },
    POWDER_M_LIFEELIXIR = { --犀茸药粉
        GENERIC = "Bé con, sao ngươi có cái này? Không đắc tội với ai đấy chứ?",
        LEARNED = "Bé con, dừng tay lại đi.",
        WRONGSTATE = nil,
    },
    POWDER_M_CHARGED = { --惊厥药粉
        GENERIC = "Nghiền thứ này dễ bị điện giật, phải vô cùng cẩn thận.",
        LEARNED = "Trời ơi, những gì ta dạy ngươi, ngươi quên sạch rồi à?",
        WRONGSTATE = nil,
    },
    POWDER_M_IMPROVEHEALTH = { --活血药粉
        GENERIC = "Món này rất dính, phải cần thêm phụ gia, nghe chưa.",
        LEARNED = "Ta không quên nổi cái vị ngọt này.",
        WRONGSTATE = nil,
    },
    POWDER_M_COLDEYE = { --寒眸药粉
        GENERIC = "Vật của yêu tà, thường dùng để lấy độc trị độc",
        LEARNED = "Trách không được ta rùng cả mình, mang đi mang đi.",
        WRONGSTATE = nil,
    },
    POWDER_M_BECOMESTAR = { --夜明药粉
        GENERIC = "Sau khi tán nhuyễn thì trộn với bột tạo hương rồi thoa lên cho da rạng rỡ, hiểu chưa",
        LEARNED = "Cái này ta không thiếu, bé con ngươi dùng đi",
        WRONGSTATE = nil,
    },
    POWDER_M_TAKEITEASY = { --排郁药粉
        GENERIC = "Nếu thấy quá buồn chán, ngươi cứ ra ngoài đi chơi giải sầu",
        LEARNED = "Cảm ơn, có ngươi làm bạn ta thật thấy vui vẻ hơn.",
        WRONGSTATE = nil,
    },

    SONG_M_WORKUP = { --《田中乐》
        GENERIC = "Bầy ong cần cù vất vả, bé con ngươi phải học bọn chúng, nhớ không được lười biếng lêu lổng",
        LEARNED = "Đừng đùa nữa, thuốc hôm nay nghiền xong chưa?",
        WRONGSTATE = nil,
    },
    SONG_M_INSOMNIA = { --《春光曲》
        GENERIC = "Cảm giác nhớ nhung cũng chẳng dễ chịu gì, đêm nằm không ngủ được",
        LEARNED = "Bé con đừng nghĩ nhiều nữa, chú ý nghỉ ngơi.",
        WRONGSTATE = nil,
    },
    SONG_M_FIREIMMUNE = { --《浴火奏》
        GENERIC = "Dục hỏa trùng sinh, giống như phượng hoàng",
        LEARNED = "Ta không cần, ngươi cứ cầm đi",
        WRONGSTATE = nil,
    },
    SONG_M_ICEIMMUNE = { --《Hàn Phong Điệu》
        GENERIC = "Đánh đàn tỳ bà với âm điệu Hàn Phong, đóng băng khắp nơi.",
        LEARNED = "Sự ấm áp này khiến ta nhớ đến cái lạnh của Thiềm Cung.",
        WRONGSTATE = "Thiềm Cung không thiếu cục đá bình thường này.",
    },
    SONG_M_ICESHIELD = { --《Mộng Phi Sương》
        GENERIC = "Con cá đặc biệt, đóng băng cả vảy lẫn tim, ta muốn nuôi thử một con.",
        LEARNED = "Con à, con giữ lấy đi, ta đã có một con rồi.",
        WRONGSTATE = nil,
    },

    SONG_M_NOCURE = { --《Oán Triền Thân》
        GENERIC = "Hận người, hận mình, hận this hận that, hận vì không chịu sửa đổi.",
        LEARNED = "Thiềm Cung không cho phép quái vật vào đây, mau ném ra ngoài.",
        WRONGSTATE = nil,
    },
    SONG_M_WEAKATTACK = { --《Xuân Phong Hóa Vũ》
        GENERIC = "Dùng lòng thương cảm đối xử với vạn vật, mới có thể mưa thuận gió hòa, mạnh khỏe bình an.",
        LEARNED = "Nếu có người đã sai lại làm sai, thì ngươi nhớ không nên nhân từ.",
        WRONGSTATE = nil,
    },
    SONG_M_WEAKDEFENSE = { --《Bá Vương Ngự Giáp》
        GENERIC = "Xưa kia mong hắn cởi giáp về vườn, nhưng giờ ta lại rơi vào tình cảnh này.",
        LEARNED = "Giờ ngươi là chỗ dựa duy nhất của ta, ta không mong muốn gì nữa.",
        WRONGSTATE = nil,
    },
    SONG_M_NOLOVE = { --《Lưu Thủy Vô Tình》
        GENERIC = "Xưa kia giọng nói người ấy vọng bên tai, đã cùng tiếng sóng hướng về đông.",
        LEARNED = "Ngươi đi đi, ta muốn một mình ở đây.",
        WRONGSTATE = nil,
    },
    SONG_M_SWEETDREAM = { --《Dạ Lan Dao》
        GENERIC = "Rất tốt, hôm nào đêm khuya khó ngủ, thì thổi một bản nhạc để giải tỏa.",
        LEARNED = "Trong cung thường chỉ có ngươi và ta, thêm người nữa để làm gì.",
        WRONGSTATE = nil,
    },
}

---------------------------------------------------------------------

STRINGS.NAMES.MYTH_GHG = "Quảng Hàn Cung" --广寒宫名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_GHG = "Tinh phách của Minh Nguyệt"
--广寒宫检查

STRINGS.NAMES.MYTH_CHANG_E = "Hằng Nga" --嫦娥名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_CHANG_E = "Lăng Ba tiên tử đến thế gian"
--嫦娥检查

STRINGS.NAMES.MYTH_INTERIORS_GHG_LU = "Lư Hương" --广寒宫的炉子
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GHG_LU = "Lư Hương"
--广寒宫的炉子检查
STRINGS.NAMES.MYTH_INTERIORS_GHG_LIGHT = "Cung Đăng" --广寒宫的灯
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GHG_LIGHT = "Cung Đăng"
--广寒宫的灯检查
STRINGS.NAMES.MYTH_INTERIORS_GHG_FLOWER = "Chậu Cảnh Mặt Trăng" --广寒宫的月花
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GHG_FLOWER = "Chậu Cảnh Mặt Trăng"
--广寒宫的月花检查
STRINGS.NAMES.MYTH_INTERIORS_GHG_HE_RIGHT = "Tiên Hạc" --广寒宫的仙鹤
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GHG_HE_RIGHT = "Tiên Hạc"
--广寒宫的仙鹤检查
STRINGS.NAMES.MYTH_INTERIORS_GHG_HE_LEFT = "Tiên Hạc" --广寒宫的仙鹤
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GHG_HE_LEFT = "Tiên Hạc"
--广寒宫的仙鹤检查

STRINGS.NAMES.MYTH_REDLANTERN = "Đèn Lồng" --灯笼名字
STRINGS.RECIPE_DESC.MYTH_REDLANTERN = "Một cái đèn lồng Trung Quốc cổ xưa"
--灯笼配方描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_REDLANTERN = "Sự ấm áp trong bóng tối"
--灯笼检查

STRINGS.NAMES.MYTH_REDLANTERN_GROUND = "Giá Đèn Lồng" --灯笼架子名字
STRINGS.RECIPE_DESC.MYTH_REDLANTERN_GROUND = "Treo đèn lồng của bạn lên"
--灯笼架子配方描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_REDLANTERN_GROUND = "Kể ra cũng tiện"
--灯笼架子检查

STRINGS.NAMES.MYTH_RUYI = "Doanh Nguyệt Như Ý" --如意名字
STRINGS.RECIPE_DESC.MYTH_RUYI = "Như Ý gõ nhẹ, quả đào tự rơi"
--如意配方描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_RUYI = "Như Ý Như Ý, làm theo ý ta, hãy mau hiển linh"
--如意检查

STRINGS.NAMES.MYTH_FENCE = "Bình Phong" --屏风名字
STRINGS.RECIPE_DESC.MYTH_FENCE = "Kiến trúc truyền thống Trung Quốc"
--屏风配方描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FENCE = "Có thể chắn gió, có thể chắn gió."
--屏风检查

STRINGS.NAMES.MYTH_BBN = "Doanh Nguyệt Bách Bảo Nang" --百宝囊名字
STRINGS.RECIPE_DESC.MYTH_BBN = "Cần phải rót ánh trăng vào"
--百宝囊配方描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_BBN = "Nhớ bổ sung năng lượng kịp thời"
--百宝囊检查

STRINGS.NAMES.MYTH_YYLP = "Doanh Nguyệt Luân Bàn" --莹月轮盘名字
STRINGS.RECIPE_DESC.MYTH_YYLP = "Vô cùng hữu dụng"
--莹月轮盘配方描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_YYLP = "Ngỡ như mặt trăng rơi xuống trần thế"
--莹月轮盘检查

STRINGS.NAMES.MYTH_MOONCAKE_ICE = "Bánh Dẻo" --冰月饼名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_MOONCAKE_ICE = "Khiến đầu óc tỉnh táo"
--冰月饼检查

STRINGS.NAMES.MYTH_MOONCAKE_NUTS = "Bánh Trung Thu Thập Cẩm" --五仁月饼名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_MOONCAKE_NUTS = "Làm cho no bụng"
--五仁月饼检查

STRINGS.NAMES.MYTH_MOONCAKE_LOTUS = "Bánh Trung Thu Hạt Sen" --莲蓉月饼名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_MOONCAKE_LOTUS = "Khiến mình không kén ăn, ăn gì cũng được"
--莲蓉月饼检查

STRINGS.NAMES.MYTH_FLYSKILL_YT = "Sương Ngọc Vân" --霜玉云
STRINGS.RECIPE_DESC.MYTH_FLYSKILL_YT = "Sương lạnh nổi lên, chân đạp mây xanh" --霜玉云配方描述

STRINGS.NAMES.MYTH_CHANG_E_FURNITURE = "Đệm" --嫦娥旁边的垫子名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_CHANG_E_FURNITURE = "Có thể nghỉ ngơi một chút"
--垫子检查

STRINGS.NAMES.MYTH_CASH_TREE_GROUND = "Dao Tiền Thụ" --摇钱树名字
STRINGS.RECIPE_DESC.MYTH_CASH_TREE_GROUND = "Bạn sẽ nhận được rất nhiều châu báu"
--百宝囊配方描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_CASH_TREE_GROUND = "Dao Tiền Thụ trong thần thoại phương đông"
--摇钱树检查
STRINGS.NAMES.MYTH_CASH_TREE_GROUND_RECIPE = STRINGS.NAMES.MYTH_CASH_TREE_GROUND

STRINGS.NAMES.MYTH_CASH_TREE = "Mầm Dao Tiền Thụ" --摇钱树树苗名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_CASH_TREE = "Vẫn chưa lớn"
--摇钱树树苗检查

STRINGS.NAMES.MYTH_TREASURE_BOWL = "Tụ Bảo Bồn" --聚宝盆名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_TREASURE_BOWL = "Lợi hại hơn Điểm Kim Thuật rất nhiều"
--聚宝盆检查

STRINGS.NAMES.MYTH_SMALL_GOLDFROG = "Tiểu Kim Thiềm" --小金蟾名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_SMALL_GOLDFROG = "Thủ hạ của Kim Thiềm"
--小金蟾检查

STRINGS.NAMES.MYTH_GOLDFROG_BASE = "Nguyên Bảo Tượng" --元宝雕像名字 挖boss 用的
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_GOLDFROG_BASE = "Tốt nhất nên cẩn thận chút"
--元宝雕像检查

STRINGS.NAMES.MYTH_GOLDFROG = "Tụ Bảo Kim Thiềm" --大蛤蟆名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_GOLDFROG = "Trên người nó có rất nhiều bảo vật"
--大蛤蟆检查

STRINGS.NAMES.MYTH_COIN = "Tiền Đồng" --铜钱名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_COIN = "Trời tròn đất vuông, chiêu gọi tiền tài"
--铜钱检查

STRINGS.NAMES.MYTH_FENCE_ITEM = STRINGS.NAMES.MYTH_FENCE
STRINGS.RECIPE_DESC.MYTH_FENCE_ITEM = STRINGS.RECIPE_DESC.MYTH_FENCE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FENCE_ITEM = STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FENCE

STRINGS.NAMES.MYTH_FENCE_ITEM_BLUEPRINT = STRINGS.NAMES.MYTH_FENCE .. STRINGS.NAMES.BLUEPRINT
STRINGS.RECIPE_DESC.MYTH_FENCE_ITEM_BLUEPRINT = STRINGS.RECIPE_DESC.MYTH_FENCE

STRINGS.NAMES.MYTH_REDLANTERN_GROUND_BLUEPRINT = STRINGS.NAMES.MYTH_REDLANTERN_GROUND .. STRINGS.NAMES.BLUEPRINT
STRINGS.RECIPE_DESC.MYTH_REDLANTERN_GROUND_BLUEPRINT = STRINGS.RECIPE_DESC.MYTH_REDLANTERN_GROUND

STRINGS.NAMES.MYTH_REDLANTERN_BLUEPRINT = STRINGS.NAMES.MYTH_REDLANTERN .. STRINGS.NAMES.BLUEPRINT
STRINGS.RECIPE_DESC.MYTH_REDLANTERN_BLUEPRINT = STRINGS.RECIPE_DESC.MYTH_REDLANTERN

STRINGS.RECIPE_DESC.MYTH_INTERIORS_GHG_LIGHT = STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GHG_LIGHT
STRINGS.NAMES.MYTH_INTERIORS_GHG_LIGHT_BLUEPRINT = STRINGS.NAMES.MYTH_INTERIORS_GHG_LIGHT .. STRINGS.NAMES.BLUEPRINT
STRINGS.RECIPE_DESC.MYTH_INTERIORS_GHG_LIGHT_BLUEPRINT = STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GHG_LIGHT

STRINGS.NAMES.MYTH_INTERIORS_GHG_GROUNDLIGHT = STRINGS.NAMES.MYTH_INTERIORS_GHG_LIGHT
STRINGS.RECIPE_DESC.MYTH_INTERIORS_GHG_GROUNDLIGHT = STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GHG_LIGHT
STRINGS.NAMES.MYTH_INTERIORS_GHG_GROUNDLIGHT_BLUEPRINT = STRINGS.NAMES.MYTH_INTERIORS_GHG_LIGHT .. STRINGS.NAMES.BLUEPRINT
STRINGS.RECIPE_DESCMYTH_INTERIORS_GHG_GROUNDLIGHT_BLUEPRINT = STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_INTERIORS_GHG_LIGHT

STRINGS.RECIPE_DESC.MYTH_INTERIORS_GHG_FLOWER = STRINGS.NAMES.MYTH_INTERIORS_GHG_FLOWER
STRINGS.NAMES.MYTH_INTERIORS_GHG_FLOWER_BLUEPRINT = STRINGS.NAMES.MYTH_INTERIORS_GHG_FLOWER .. STRINGS.NAMES.BLUEPRINT
STRINGS.RECIPE_DESC.MYTH_INTERIORS_GHG_FLOWER_BLUEPRINT = STRINGS.NAMES.MYTH_INTERIORS_GHG_FLOWER

STRINGS.RECIPE_DESC.MYTH_INTERIORS_GHG_HE_LEFT = STRINGS.NAMES.MYTH_INTERIORS_GHG_HE_LEFT
STRINGS.NAMES.MYTH_INTERIORS_GHG_HE_LEFT_BLUEPRINT = STRINGS.NAMES.MYTH_INTERIORS_GHG_HE_LEFT .. STRINGS.NAMES.BLUEPRINT
STRINGS.RECIPE_DESC.MYTH_INTERIORS_GHG_HE_LEFT_BLUEPRINT = STRINGS.NAMES.MYTH_INTERIORS_GHG_HE_LEFT

STRINGS.RECIPE_DESC.MYTH_INTERIORS_GHG_HE_RIGHT = STRINGS.NAMES.MYTH_INTERIORS_GHG_HE_RIGHT
STRINGS.NAMES.MYTH_INTERIORS_GHG_HE_RIGHT_BLUEPRINT = STRINGS.NAMES.MYTH_INTERIORS_GHG_HE_RIGHT .. STRINGS.NAMES.BLUEPRINT
STRINGS.RECIPE_DESC.MYTH_INTERIORS_GHG_HE_RIGHT_BLUEPRINT = STRINGS.NAMES.MYTH_INTERIORS_GHG_HE_RIGHT

STRINGS.RECIPE_DESC.MYTH_INTERIORS_GHG_LU = STRINGS.NAMES.MYTH_INTERIORS_GHG_LU
STRINGS.NAMES.MYTH_INTERIORS_GHG_LU_BLUEPRINT = STRINGS.NAMES.MYTH_INTERIORS_GHG_LU .. STRINGS.NAMES.BLUEPRINT
STRINGS.RECIPE_DESC.MYTH_INTERIORS_GHG_LU_BLUEPRINT =STRINGS.NAMES.MYTH_INTERIORS_GHG_LU


STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_DOOR_EXIT_2 = "Ta nên chú ý thời gian rời đi"

STRINGS.MYTH_SKIN_ALCHMY_FUR_COPPER = "Lò Bát Quái"
STRINGS.MYTH_SKIN_ALCHMY_FUR_RUINS = "Lò Chuyển Hóa Bóng Tối"

STRINGS.MYTH_SKIN_REDLANTERN_MYTH_B = "Hoa Sen"
STRINGS.MYTH_SKIN_REDLANTERN_MYTH_C = "Lụa Hoa"
STRINGS.MYTH_SKIN_REDLANTERN_MYTH_D = "Đèn Kéo Quân"
STRINGS.MYTH_SKIN_REDLANTERN_MYTH_E = "Trăng tròn"
STRINGS.MYTH_SKIN_REDLANTERN_MYTH_F = "枯骨寒"
STRINGS.MYTH_SKIN_REDLANTERN_MYTH_G = "蛛丝缠"
STRINGS.MYTH_SKIN_REDLANTERN_MYTH_H = "引魄灯"
STRINGS.MYTH_SKIN_REDLANTERN_MYTH_I = "明玕照"

STRINGS.NAMES.FARM_PLANT_GOURD = "Cây Hồ Lô"
STRINGS.NAMES.GOURD_OVERSIZED = "Hô Lô Khổng Lồ"
STRINGS.NAMES.GOURD_OVERSIZED_ROTTEN = "Hồ Lô Khổng Lồ Thối Rữa"
STRINGS.UI.PLANTREGISTRY.DESCRIPTIONS.GOURD = "Xin chuyên tâm chăm sóc!"
STRINGS.NAMES.KNOWN_GOURD_SEEDS = "Hạt Giống Hồ Lô"

STRINGS.NAMES.MYTH_YJP = "Dương Chi Ngọc Tịnh Bình"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_YJP = "Bình sứ chứa đầy hơi thở sự sống"

STRINGS.NAMES.MYTH_GRANARY = "Kho Thóc"
STRINGS.RECIPE_DESC.MYTH_GRANARY = "Là kiến trúc chuyên dùng để chứa lượng lớn lương thực"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_GRANARY = "Xuân cày bừa Hè làm cỏ, Thu để dành Đông cất trữ"

STRINGS.NAMES.MYTH_TUDI_SHRINES = "Miếu Thổ Địa"
STRINGS.RECIPE_DESC.MYTH_TUDI_SHRINES = "Nơi người cư trú, cũng để thờ cúng"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_TUDI_SHRINES = "Rượu vàng rượu bạc sao cũng được, gà trống gà mái phải béo tròn"

STRINGS.NAMES.MYTH_WELL = "Giếng Nước"
STRINGS.RECIPE_DESC.MYTH_WELL = "Trong veo sạch sẽ, đông ấm hè mát"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_WELL = "Nước giếng rất trong"

STRINGS.NAMES.MOVEMOUNTAIN_PILL = "Di Sơn Đan"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MOVEMOUNTAIN_PILL = "Dùng đan này ngay cả Wolfgang cũng không phải là đối thủ của ta"

STRINGS.NAMES.MYTH_TUDI = "Thổ Địa Công Công"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_TUDI = "Ngươi cũng là thần tiên sao"

STRINGS.MYTH_TUDI_TRADE = "Có qua không có lại, không phải phép tắc"
STRINGS.MYTH_TUDI_ALREADYTRADE = "Lão già tuy hưởng lộc, nhưng cũng không ham tài"

STRINGS.MYTH_TUDI_TIRED = {"Cày đồng đang buổi ban trưa, mồ hôi thánh thót như mưa ruộng cày", "Ôi chao cái lưng già của ta", "Mưa thuận gió hòa, non xanh nước biếc"}

STRINGS.MYTH_TUDI_ROTTEN_SPEAK = {"Khắp nơi không có ruộng bỏ không, nông dân vẫn chết đói", "Hạt gạo tuy nhỏ nhưng không dễ gì có được, đừng đem sự khó khăn làm trò đùa"}
STRINGS.MYTH_TUDI_RUNAWAY = "Pháp lực tiểu thần thấp kém, xin chào thân ái và quyết thắng!"

STRINGS.MYTH_TUDI_PLAYER_SPEAK = {
    common = {"Đa tạ thí chủ đã đến thờ cúng", "Mong hiền sĩ mưa thuận gió hòa, được hưởng an lạc"},
    monkey_king = {"Không biết Đại Thánh đến đây, không tiếp đón từ xa, mong tha tội", "Đại Thánh có căn dặn gì hông?"},
    neza = {"Xin nghe Tam Thái Tử căn dặn", "Tam Thái Tử có việc gì quan trọng muốn nói cho lão già này"},
    white_bone = {"Yêu quái đến rồi sao?"},
    pigsy = {"Thiên Bồng Nguyên Soái, miếu nhỏ của ta ít ai thờ cúng, xin ngài thủ hạ lưu tiền", "Nếu Nguyên Soái muốn vòi tiền, nên kiếm nhà khác đi"},
    myth_yutu = {"Con thỏ con nhà ngươi, lại trốn ra đây chơi rồi", "Đợi lát Hằng Nga đến đưa ngươi về"},
    yangjian = {"Chân Quân có pháp chỉ điều động", "Chân Quân ghé chơi, thật vẻ vang cho kẻ hèn?"}
}

STRINGS.NAMES.MYTH_TOY_FEATHERBUNDLE = "Cầu Đá"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_TOY_FEATHERBUNDLE = "Khóm hoa nơi mũi chân, chim hồng xuyên mây đến"

STRINGS.NAMES.MYTH_TOY_TIGERDOLL = "Con Hổ Vải"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_TOY_TIGERDOLL = "Kháu khỉnh bụ bẫm, thật là đáng yêu"

STRINGS.NAMES.MYTH_TOY_TUMBLER = "Lật Đật Thổ Địa"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_TOY_TUMBLER = "Chế tác hoàn mỹ, rất giống ông thổ địa"

STRINGS.NAMES.MYTH_TOY_TWIRLDRUM = "Trống Bỏi"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_TOY_TWIRLDRUM = "Tung tung tung tung tung tung"

STRINGS.NAMES.MYTH_TOY_CHINESEKNOT = "Nơ Trung Quốc"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_TOY_CHINESEKNOT = "Nơ may mắn cả năm"

STRINGS.NAMES.MYTH_FOOD_TABLE = "Bàn Ăn Gỗ Lim"
STRINGS.RECIPE_DESC.MYTH_FOOD_TABLE = "Bàn ăn đỏ rực, là không khí tết vui mừng"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_TABLE = "Cả năm sum họp sum vầy"

STRINGS.NAMES.MYTH_FOOD_SJ = "Sủi Cảo"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_SJ = "Cuộc thi món bánh nước tạo nên niềm vui cho năm mới, mùi thơm mỗi loại còn lưu lại trên môi."

STRINGS.NAMES.MYTH_FOOD_BZ = "Bánh Bao Thịt"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_BZ = "Buổi sáng đẹp đẽ, bắt đầu từ một phần bánh bao lớn"

STRINGS.NAMES.MYTH_FOOD_XJDMG = "Gà Hầm Nấm"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_XJDMG = "Thiên Vương Cái Địa Hổ, gà con hầm nấm rơm!"

STRINGS.NAMES.MYTH_FOOD_HSY = "Cá Kho Sốt Cay"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_HSY = "Ấm bụng êm lòng"

STRINGS.NAMES.MYTH_FOOD_BBF = "Cơm Bát Bửu"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_BBF = "Ngọt mà không ngán, rất nhiều lợi ích"

STRINGS.NAMES.MYTH_FOOD_CJ = "Gỏi Cuốn Trăng Khuyết"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_CJ = "Bó lấy ánh trăng, gửi vào lòng em"

STRINGS.NAMES.MYTH_FOOD_HLBZ = "Nước Ép Cà Rốt"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_HLBZ = "Dưỡng da sáng mắt, dành riêng người đẹp"

STRINGS.NAMES.MYTH_FOOD_LWHZ = "Thịt Khô Hấp Bí"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_LWHZ = "Nạc nhưng rất xốp, thơm nhưng không ngấy. Vị ngon tràn miệng, mùi thơm nức mũi."

STRINGS.NAMES.MYTH_FOOD_TSJ = "Rượu Đồ Tô"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_TSJ = "Gió xuân đưa sự ấm áp vào Đồ Tô"

STRINGS.NAMES.MYTH_FOOD_TR = "Kẹo Đường"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_TR = "Người đó là đại anh hùng trong thần thoại"

STRINGS.TUDI_SHRINES_NEEDGOODFOOD = "Cúng tế thổ địa, ăn nhiều nấu nhiều."
STRINGS.TUDI_SHRINES_NEEDOTHERFOOD = "Nhu cầu đa dạng, cần thêm món khác."
STRINGS.TUDI_SHRINES_REFUSEFOOD = "Lòng này mãi nhớ, thẹn không dám nhận."

STRINGS.NAMES.BOOKINFO_MYTH = "Thiên Thư"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOKINFO_MYTH = "Đây là một quyển bảo điển ghi chép rất nhiều bí mật"

STRINGS.NAMES.MYTH_HONEYPOT = "Hũ Mật"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_HONEYPOT = "Bỏ đầy mật ong vào hũ sẽ rất bất ngờ"

STRINGS.NAMES.LAOZI_BELL = "Đâu Suất Ngưu Linh"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAOZI_BELL = "Chuông do Thái Thượng Lão Quân làm cho Thanh Ngưu"

STRINGS.NAMES.LAOZI_BELL_BROKEN = "Chuông Vỡ"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAOZI_BELL_BROKEN = "Hư hại rất nhiều, có lẽ lò luyện đan có thể sửa"

STRINGS.NAMES.SADDLE_QINGNIU = "Đâu Suất Ngưu An"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SADDLE_QINGNIU = "Yên do Thái Thượng Lão Quân làm cho Thanh Ngưu"

STRINGS.NAMES.LAOZI_QINGNIU = "Bản Giác Thanh Ngưu"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAOZI_QINGNIU = "Thụy thú thượng cổ 'Tự'"

STRINGS.ACTIONS.CASTAOE.MYTH_QXJ = "Nhất Xích Hàn Quang"
STRINGS.ACTIONS.CASTAOE.MYTH_WEAPON_SYF = "Hàn Băng Hoành Tảo"
STRINGS.ACTIONS.CASTAOE.MYTH_WEAPON_GTT = "Súc Lực Trọng Chùy"
STRINGS.ACTIONS.CASTAOE.MYTH_WEAPON_SYD = "Chích Nhiệt Trọng Trảm"
STRINGS.ACTIONS.CASTAOE.CANE_PEACH = "弃杖化林"

STRINGS.MYTH_SKIN_GROUNDLIGHT_STD = "Thạch Tháp Đăng"
STRINGS.MYTH_SKIN_GROUNDLIGHT_RYX = "Như Ý Tiêu"
STRINGS.MYTH_SKIN_GROUNDLIGHT_QZH = "Thanh Trúc Huy"
STRINGS.MYTH_SKIN_GROUNDLIGHT_LLT = "Linh Lung Tháp"
STRINGS.MYTH_SKIN_GROUNDLIGHT_BGZ = "Bạch Cốt Chi"
STRINGS.MYTH_SKIN_GROUNDLIGHT_BLZ = "Bảo Liên Trản"
STRINGS.MYTH_SKIN_GROUNDLIGHT_GXY = "Quế Hương Doanh"
STRINGS.MYTH_SKIN_GROUNDLIGHT_YHY = "U Hồn Dẫn"
STRINGS.MYTH_SKIN_GROUNDLIGHT_CXH = "翠镶红"
STRINGS.MYTH_SKIN_GROUNDLIGHT_ZSZ = "蛛设织"

STRINGS.NAMES.MYTH_SIVING_BOSS = "Tử Khuê Huyền Điểu"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_SIVING_BOSS = "Bắc Hải có núi, tên là U Đô. Hắc Thủy đi đâu, trên có Huyền Điểu"

STRINGS.NAMES.SIVING_ROCKS = "Tử Khuê Thạch"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SIVING_ROCKS = "Sức mạnh sinh mệnh dao động bên trong"

STRINGS.NAMES.SIVING_STONE = "Tử Khuê Thanh Kim"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SIVING_STONE = "Phật không hỏi tên, Đạo không hỏi tuổi, thiên hạ rộng lớn, trường sinh bất diệt"

STRINGS.NAMES.ARMORSIVING = "Tử Khuê Chiến Giáp"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMORSIVING = "Địch đông như kiến, ta vẫn xông lên."

STRINGS.NAMES.SIVING_HAT = "Tử Khuê Chiến Khôi"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMORSIVING = "Tuy đã chết nhưng sĩ khí vẫn còn!"

STRINGS.NAMES.MYTH_PLANT_LOTUS = "Gốc Hoa Sen"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_LOTUS = "Sen vừa lộ góc nhỏ, thì chuồn chuồn đã đậu lên." --待修改

STRINGS.NAMES.MYTH_LOTUS_FLOWER = "Hoa Sen"
STRINGS.RECIPE_DESC.MYTH_LOTUS_FLOWER = "Lóc xương trả cha, lóc thịt trả mẹ"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_LOTUS_FLOWER = "Mùi hương càng xa càng dịu"

STRINGS.NAMES.LOTUS_ROOT = "Củ Sen"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LOTUS_ROOT = "Trong mát ngon miệng"

STRINGS.NAMES.LOTUS_ROOT_COOKED = "Củ Sen Nướng"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LOTUS_ROOT_COOKED = "Giòn mềm vừa phải, không như ăn sống"

STRINGS.NAMES.LOTUS_SEEDS = "Hạt Sen"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LOTUS_SEEDS = "Vị ngọt thanh, rất tốt cho dạ dày"

STRINGS.NAMES.LOTUS_SEEDS_COOKED = "Hạt Sen Nướng"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LOTUS_SEEDS_COOKED = "Hạt sen thơm mềm, làm ấm trái tim bạn."

STRINGS.NAMES.MYTH_LOTUSLEAF = "Lá Sen"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_LOTUSLEAF = "Một đêm mưa gió, quét bỏ bụi trần"

STRINGS.NAMES.MYTH_LOTUSLEAF_HAT = "Nón Lá Sen"
STRINGS.RECIPE_DESC.MYTH_LOTUSLEAF_HAT = "Gió thổi lá sen hương bay xa"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_LOTUSLEAF_HAT = "người lớn thì cười trẻ em thì thích"

STRINGS.NAMES.MYTH_FOOD_LZG = "Hạt Sen Chưng Đường Phèn"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_LZG = "Bồi bổ bao tử, giữ ấm cho tim"

STRINGS.NAMES.MYTH_FOOD_ZYOH = "Hộp Củ Sen Trăng Khuyết"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_ZYOH = "Hương thơm ngào ngạt, hoa mãn trăng đầy"

STRINGS.NAMES.MYTH_FOOD_PGT = "Canh Sườn Củ Sen"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_PGT = "Để ta xem nguyên liệu là 2 phần xương sườn và 1 phần... Na Tra?"

STRINGS.NAMES.MYTH_FOOD_HBJ = "Gà Ăn Mày"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_HBJ = "Hương thơm nức mũi, bày biện ưa nhìn"

STRINGS.NAMES.MYTH_WEAPON_SYF = "Sương Việt Phủ"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_WEAPON_SYF = "Đúc từ nước Khảm, lạnh giá dị thường, cẩn thận bị thôn phệ"

STRINGS.NAMES.MYTH_WEAPON_SYD = "Thử Tập Đao"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_WEAPON_SYD = "Đúc từ lửa Ly, lửa lớn sẽ đốt mọi thứ xung quanh"

STRINGS.NAMES.MYTH_WEAPON_GTT = "Cột Thát Đằng"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_WEAPON_GTT = "Đúc từ gió Tốn, có thể điều động sức mạnh cát đá"

STRINGS.NAMES.MYTH_QXJ = "Thất Tinh Kiếm"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_QXJ = "Tê Ngưu Lục Thuộc Khải, Bảo Kiếm Thất Tinh Quang"

STRINGS.NAMES.MYTH_RHINO_BLUEHEART = "Tích Hàn Tâm"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_RHINO_BLUEHEART = "Trái tim tràn đầy linh lực nước Khảm"

STRINGS.NAMES.MYTH_RHINO_REDHEART = "Tích Thử Tâm"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_RHINO_REDHEART = "Trái tim tràn đầy linh lực lửa Ly"

STRINGS.NAMES.MYTH_RHINO_YELLOWHEART = "Tích Trần Tâm"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_RHINO_YELLOWHEART = "Trái tim tràn đầy linh lực gió Tốn"

STRINGS.NAMES.TURF_MYTH_ZHU = "Nền Đất Cỏ"
STRINGS.RECIPE_DESC.TURF_MYTH_ZHU = "Nền Đất Cỏ"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TURF_MYTH_ZHU = "Nền Đất Cỏ."

STRINGS.NAMES.TURF_QUAGMIRE_PARKFIELD = "Đất vườn đào"
STRINGS.RECIPE_DESC.TURF_QUAGMIRE_PARKFIELD = "Rực rỡ hoa đào hòa bùn đất"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TURF_QUAGMIRE_PARKFIELD = "Cỏ thơm tươi đẹp, hoa rụng phất phơ"

STRINGS.NAMES.MYTH_PLANT_BAMBOO = "Cây Trúc"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO = "Trúc xanh khắp nơi, đâm chồi nẩy mầm"

STRINGS.NAMES.MYTH_BAMBOO = "Ống Trúc"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_BAMBOO = "Bốn mùa xanh tươi, chịu sương chịu tuyết"

STRINGS.NAMES.MYTH_GREENBAMBOO = "Trúc Xanh"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_GREENBAMBOO = "Không trải qua mưa gió, khó trở thành trúc xanh"

STRINGS.NAMES.MYTH_BAMBOO_SHOOTS = "Măng"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_BAMBOO_SHOOTS = "Sống không thể không có Trúc, ăn không thể không có măng"

STRINGS.NAMES.MYTH_BAMBOO_SHOOTS_COOKED = "Măng Nướng"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_BAMBOO_SHOOTS_COOKED = "Măng rất nhanh hư, nướng lên sẽ giữ được lâu hơn"

STRINGS.NAMES.MYTH_FOOD_ZTF = "Cơm Lam"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_ZTF = "Nước miếng chảy dài, mùi thơm nức mũi"

STRINGS.NAMES.MYTH_FOOD_ZSCR = "Măng Xào Thịt"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_ZSCR = "Ta mời ngươi ăn măng xào thịt?"

STRINGS.NAMES.MYTH_FUCHEN = "Phất Trần"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FUCHEN = "Luôn luôn phe phẩy, chẳng nhiễm bụi trần"

STRINGS.LZOZI_QINGNIU_EATPILL = {
    SX = "Tro trong lò của Lão Quân còn ngon hơn",
    TY = "Mây nổi sương lên",
    ZG = "Bất động như núi",
    NS = "Nín thở tập trung",
}

STRINGS.MYTH_LAOZIPACK = "Phong Ấn"

STRINGS.NAMES.KRAMPUSSACK_SEALED = "Túi Krampus Phong Ấn"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KRAMPUSSACK_SEALED = "Nguyên liệu luyện Tử Kim Hồ Lô!"

STRINGS.NAMES.MYTH_STATUE_PANDAMAN = "Tượng Anh Hùng Thần Bí"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_STATUE_PANDAMAN = "Tượng Anh Hùng Thần Bí"

STRINGS.NAMES.MYTH_STORE = "Cửa Hàng Đóng Cửa"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_STORE = "Cửa Hàng Đóng Cửa"

STRINGS.NAMES.MYTH_STORE_CONSTRUCTION = "Cửa Hàng Đang Xây Dựng"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_STORE_CONSTRUCTION = "Cửa Hàng Đang Xây Dựng"


STRINGS.NAMES.MYTH_PASSCARD_JIE = "Thông Thiên Sắc Lệnh"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PASSCARD_JIE = "‘Dạy Dỗ Không Kỳ Thị’, lệnh bài của Thông Thiên Giáo Chủ, một trong Tam Thanh."

STRINGS.USE_MIRROR = "Thay đồ"

STRINGS.NAMES.MYTH_PLANT_BAMBOO_0 = "Măng đã trồng"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO_0 = "Lớn nào, lớn nào."
STRINGS.NAMES.MYTH_PLANT_BAMBOO_1 = "Mầm Trúc"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO_1 = "Lớn nào, lớn nào."
STRINGS.NAMES.MYTH_PLANT_BAMBOO_2 = "Mầm Trúc"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO_2 = "Lớn nào, lớn nào."
STRINGS.NAMES.MYTH_PLANT_BAMBOO_3 = "Trúc Xanh"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO_3 = "Trúc xanh khắp nơi, đâm chồi nảy mầm."
STRINGS.NAMES.MYTH_PLANT_BAMBOO_4 = "Trúc Xanh"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO_4 = "Trúc xanh khắp nơi, đâm chồi nảy mầm."
STRINGS.NAMES.MYTH_PLANT_BAMBOO_5 = "Trúc Xanh"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO_5 = "Bè khô còn mượn xuân lấy gió, Trúc xanh chịu lạnh đó tới nay"
STRINGS.NAMES.MYTH_PLANT_BAMBOO_STUMP = "Cọc Trúc"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO_STUMP = "Tan xương nát thịt cũng không sợ."
STRINGS.NAMES.MYTH_PLANT_BAMBOO_BURNT = "Trúc Cháy"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_PLANT_BAMBOO_BURNT = "Phải để lại sự thuần khiết ở nhân gian."

STRINGS.NAMES.MYTH_HUANHUNDAN = "Hoàn Hồn Đan"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_HUANHUNDAN = "Hoàn hồn đan, cứu được người chết rục cả xương"

--特殊新加
STRINGS.NAMES.MYTH_TOY_BOOKINFO = "Đồ chơi thần thoại" --玩具的名字
STRINGS.NAMES.MYTH_PIGSYSKILL_BOOKINFO = "Cương Liệp Bản Tướng" --八戒的技能

STRINGS.NAMES.MYTH_FLYSKILL_YA = "U Minh Thân"
STRINGS.RECIPE_DESC.MYTH_FLYSKILL_YA = "Hồng trần cuồn cuộn, nhập thế câu hồn"

STRINGS.USE_MYTH_SKELETON = "Mai táng"

STRINGS.NAMES.MYTH_MOONCAKE_BOX = "Hộp Bánh Trung Thu"
STRINGS.RECIPE_DESC.MYTH_MOONCAKE_BOX = "Trăng non cong cong, hạnh phúc ngập lòng"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_MOONCAKE_BOX = "Hộp bánh trung thu tinh xảo tuyệt vời"

STRINGS.NAMES.MYTH_COIN_BOX = "Xâu Tiền Đồng"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_COIN_BOX = "Một xâu tiền lớn"

STRINGS.USE_MYTH_COIN = "Xâu tiền"
STRINGS.USE_MYTH_ASTRAL = "Nhập hồn"
STRINGS.USE_MYTH_PLAYER = "Ám vào"
STRINGS.USE_MYTH_ABSORB = "吸取"
STRINGS.USE_MYTH_DRINK = "喝"

--BUFF
STRINGS.NAMES.BUFF_M_LOCO_UP = "Đi nhanh"
STRINGS.NAMES.BUFF_M_BLOODSUCK = "Khát máu"
STRINGS.NAMES.BUFF_M_ATK_UP = "Mạnh mẽ" --增加攻击力
STRINGS.NAMES.BUFF_M_DEF_UP = "Kiên cố" --增加防御力
STRINGS.NAMES.BUFF_M_UNDEAD = "Bất tử"
STRINGS.NAMES.BUFF_M_ATK_ICE = "Ngưng sương" --攻击带冰
STRINGS.NAMES.BUFF_M_ATK_ELEC = "Ngự điện" --攻击带电
STRINGS.NAMES.BUFF_M_CHARGED = "Cảm điện" --杨戬的
STRINGS.NAMES.BUFF_M_HUNGER_STAY = "Chắc bụng"
STRINGS.NAMES.BUFF_M_SANITY_STAY = "Ngưng thần"
STRINGS.NAMES.BUFF_M_HUNGER_STRONG = "Thao thiết"
STRINGS.NAMES.BUFF_M_STRENGTH_UP = "Thần lực"
STRINGS.NAMES.BUFF_M_IMMUNE_FIRE = "Chống lửa"
STRINGS.NAMES.BUFF_M_IMMUNE_WATER = "Chống thấm"
STRINGS.NAMES.BUFF_M_WARM = "Chống lạnh"
STRINGS.NAMES.BUFF_M_COOL = "Chống nóng"
STRINGS.NAMES.BUFF_M_DUST = "Chống bụi"
STRINGS.NAMES.BUFF_M_DEATHHEART = "Tim đen" --白骨夫人的
STRINGS.NAMES.BUFF_M_ICESHIELD = "Giáp băng" --被攻击冻结敌人（单体）
STRINGS.NAMES.BUFF_M_IMMUNE_ICE = "Chống băng" --免疫冰冻
STRINGS.NAMES.BUFF_M_INSOMNIA = "Chống ngủ" --免疫催眠
STRINGS.NAMES.BUFF_M_THORNS = "Giáp gai"
STRINGS.NAMES.BUFF_M_WORKUP = "Năng suất" --工作效率提高
STRINGS.NAMES.BUFF_M_HEALTH_REGEN = "Trị liệu"
STRINGS.NAMES.BUFF_M_SANITY_REGEN = "Hồi thần"
STRINGS.NAMES.BUFF_M_HUNGER_REGEN = "No bụng"
STRINGS.NAMES.BUFF_M_GLOW = "Phát sáng"
--以下都是熊猫人铺子的
STRINGS.NAMES.BUFF_M_PROMOTE_HEALTH = "Dinh dưỡng"
STRINGS.NAMES.BUFF_M_PROMOTE_HUNGER = "Khai vị"
STRINGS.NAMES.BUFF_M_PROMOTE_SANITY = "Mỹ vị"
STRINGS.NAMES.BUFF_M_STENCH = "Thơm tho"
STRINGS.NAMES.BUFF_M_THORNS = "荆棘"
STRINGS.NAMES.BUFF_M_BEEFALO = "牛息"
STRINGS.NAMES.BUFF_M_FU = "福"
STRINGS.NAMES.BUFF_M_LU = "禄"
STRINGS.NAMES.BUFF_M_SHOU = "寿"
STRINGS.NAMES.BUFF_M_INFANT = "长生不老"

--------------------------------------------------------------------------
--[[ 青竹洲店铺 ]]
--------------------------------------------------------------------------

STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.TRADE_BBSHOP_M = {
    CLOSED = "啊哦，居然打烊了。",
    OCCUPIED = "排队可是个好习惯！",
}
STRINGS.ACTIONS.TRADE_BBSHOP_M = "进去瞧瞧"

STRINGS.NAMES.MYTH_SHOP_RAREITEM = "珍奇小摊"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_SHOP_RAREITEM = "这店主贼喜欢些稀奇古怪的玩意儿。"

STRINGS.NAMES.MYTH_SHOP_INGREDIENT = "菜市小铺"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_SHOP_INGREDIENT = "这里卖的瓜果肉蛋，保熟吗？"

STRINGS.NAMES.MYTH_SHOP_ANIMALS = "花鸟小铺"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_SHOP_ANIMALS = "是家有趣的可爱小动物交易铺。"

STRINGS.NAMES.MYTH_SHOP_PLANTS = "禾种小铺"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_SHOP_PLANTS = "真不知道他们也不种田，怎么搞到这么多种子。"

STRINGS.NAMES.MYTH_SHOP_FOODS = "茶肴小铺"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_SHOP_FOODS = "真是个打打牙祭的好去处！"

STRINGS.NAMES.MYTH_SHOP_WEAPONS = "铸匠小铺"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_SHOP_WEAPONS = "这铺的师傅打造修理，样样精通。"

STRINGS.NAMES.MYTH_SHOP_NUMEROLOGY = "算命小铺"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_SHOP_NUMEROLOGY = "骗人的，我从不迷信。"

STRINGS.NAMES.MYTH_SHOP_CONSTRUCT = "材瓦小铺"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_SHOP_CONSTRUCT = "啊，好怀念这种逛家具店的感觉。"

STRINGS.NAMES.MYTH_IRON_BROADSWORD = "铸铁大刀"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_IRON_BROADSWORD = "大刀，向敌人们滴头上砍去。"

STRINGS.NAMES.MYTH_IRON_HELMET = "铸铁头盔"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_IRON_HELMET = "戴上它我就头铁了。"

STRINGS.NAMES.MYTH_IRON_BATTLEGEAR = "铸铁战甲"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_IRON_BATTLEGEAR = "穿上它我就是铁公鸡了。"

STRINGS.NAMES.MINIFLARE_MYTH = "窜天猴"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MINIFLARE_MYTH = "爆竹声中一岁除"

STRINGS.NAMES.FIRECRACKERS_MYTH = "爆竹"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FIRECRACKERS_MYTH = "一飞冲天，春到人间"

STRINGS.NAMES.TREASURE_SHOW_MYTH = "很正常的土堆"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TREASURE_SHOW_MYTH = "我觉得，牌子上写得对。"

STRINGS.BBSHOP = {
    BUTTON_FATE = "算卦",
    BUTTON_DO_FATE = "占一卦",
    BUTTON_TREA = "藏宝图卷轴",
    BUTTON_DO_TREA = "买一张",
    BUTTON_SEASONSEEDS = "季节种子包",
    BUTTON_DO_BUY = "购买",
    BUTTON_DO_BUYALL = "购买全部",
    BUTTON_DO_SELL = "出售",
    BUTTON_DO_SELLALL = "出售全部",
    BUTTON_DO_FIX = "修理",
    DESC = {
        FATE = "三言两语中，望你自悟天机。",
        TREA = "乾之下，坤之上，有一宝，无异相。",
        SEASONSEEDS = "随机给你一些最适合当季种植的种子。",
        FIX = "磨损严重，不如让我修缮修缮。",
        FIXED = "完好如初，暂时不需要修缮了。",
        BUY = "要买吗？",
        BUY_NONE = "已经卖光了。",
        SELL = "最近我在收购这个，你有吗？",
        SELL_NONE = "我不需要了。",
        myth_iron_broadsword = "精铁铸造的上好武器。",
        myth_iron_helmet = "精铁铸造的上好头盔。",
        myth_iron_battlegear = "精铁铸造的上好护甲。",
    },
    WORDS = {
        rareitem = {
            say_welcom = { "欢迎光临！", "欢迎欢迎！", },
            say_refuse = { "客官请别这样。", "别戏弄我啦。", },
            say_buy = { "放心吧，我可不会卖假货。", "客官真是好眼光。", "谢谢惠顾。", },
            say_buy_nocoin = { "你的钱哪去了？", "客官真会说笑。", "这点钱，很难替你办事啊。", "我得戳醒你，你钱不够。", },
            say_buy_nocount = { "抱歉，已经卖光啦。", "卖光了，再看看别的吧。", },
            say_sell = { "这个东西我就收下啦。", "客官的货可真是上好佳。", "这东西也不值钱，我就勉为其难收了。", },
            say_sell_nocount = { "客官是在开玩笑吧。", "东西呢？", },
            say_sell_noneed = { "抱歉，我不收了。", "这东西暂时不需要了。", },
        },
        ingredient = {
            say_welcom = { "欢迎，要买点啥啊？", "请随便看看。", },
            say_refuse = { "去摆弄蔬菜吧。", "别摸我啦。", },
            say_buy = { "放心吧，都是很新鲜的。", "要是坏的，包赔。", "谢谢惠顾。", "再买点呗，够吃吗。", },
            say_buy_nocoin = { "钱不够哦。", "你开玩笑的吧。", "这点钱，很难替你办事啊。", "这里概不赊账。", },
            say_buy_nocount = { "抱歉，已经卖完啦。", "卖完了，再看看别的吧。", "卖得好火，都卖光了。", },
            say_sell = { "辛苦了。", "客官的货可真是上好佳。", "这东西不太新鲜了，不过我就勉为其难收了。", },
            say_sell_nocount = { "你的货呢？", "东西呢？", "这点数量我也卖不出去。", },
            say_sell_noneed = { "抱歉，太多了我也卖不完呢。", "这菜暂时不需要了。", "够了够了，我这也没冰箱。" },
        },
        animals = {
            say_welcom = { "欢迎，一屋子小可爱等着你呢。", "建议你别乱碰，有些小可爱脾气大。", },
            say_refuse = { "我有什么好玩的。", "你也有个有趣的灵魂？", "客官还是看看别的吧。", },
            say_buy = { "要好好照顾小可爱哟。", "啊，真是好眼光。", "它也该换新主人了。", "以后就交给你了。", },
            say_buy_nocoin = { "钱不够啊。", "客官真会说笑。", "啊哦，荷包空空。", "这么可爱的动物你舍得白嫖吗？！", },
            say_buy_nocount = { "我的小可爱们已经卖光啦。", "卖光了，再看看别的小可爱吧。", },
            say_sell = { "暂时由我当它的主人啦。", "太可爱了！", "你好小家伙，别怕。", },
            say_sell_nocount = { "客官是在开玩笑吧。", "你的小可爱呢？", },
            say_sell_noneed = { "就这么大点地，装不下了。", "拥挤的环境可不适合它们。", },
        },
        plants = {
            say_welcom = { "想种点什么？", "需要什么给我说。", },
            say_refuse = { "小心点。", "别看我这个样子就好欺负。", "你找茬是吧！", },
            say_buy = { "都是今年的新种。", "既然你买了，你应该知道怎么种吧。", "每颗种子都是辛劳获取，要珍惜。", },
            say_buy_nocoin = { "这里概不赊账。", "你开玩笑的吧", },
            say_buy_nocount = { "已经卖光了。", "种点别的吧。", },
            say_sell = { "好嘞，你的辛苦没有白费。", "真大真饱满。", "我都种不出来这么好的。", "佩服你的栽种能力。", },
            say_sell_nocount = { "你在骗我吗？", "东西呢？", "我看着像傻子吗？", },
            say_sell_noneed = { "留着你自己吃吧。", "我不要了。", "你说你辛苦，我就不辛苦了？", },
        },
        foods = {
            say_welcom = { "欢迎！客官您请坐。", "想吃点啥。", "什么风把您吹来啦。", },
            say_refuse = { "客官不可以。", "别弄我啦，看菜单吧。", },
            say_buy = { "好嘞，菜马上就好！", "上菜！", "再点一些吧，还有招牌菜呢！", },
            say_buy_nocoin = { "我这不能赊账。", "客官真会说笑。", "再看看别的吧，这个你吃不起。", "你钱不够吧。", },
            say_buy_nocount = { "抱歉，已经卖完了。", "实在抱歉，卖光了。", "要不您再点些别的？", },
            say_sell = { "真是美味佳肴！", "客官的厨艺果然上乘。", "啧啧，太香了。", "我都不会这做法。", "您的厨艺可不一般。", },
            say_sell_nocount = { "巧妇难为无米之炊。", "只见客官不见菜呀。", },
            say_sell_noneed = { "抱歉，再收就是在做亏本生意了。", "暂时不需要了，明天早点来吧。", },
        },
        weapons = {
            say_welcom = { "你要打造什么？", "想订点啥？", "修缮之类的活可以放心交给我。", },
            say_refuse = { "别碰我。", "你想干什么。", "站远点，这边危险。", },
            say_buy = { "我的得意之作。", "我打造的刀剑是最锋利的。", "我打造的装甲是最坚固的。", },
            say_buy_nocoin = { "概不赊账。", "没钱就去别的地玩吧。", "再看看别的吧，这个你买不起。", "别烦我了。", },
            say_buy_nocount = { "卖完了。", "一把好剑可没那么容易锻造出来。", "看看别的吧，没库存了。", },
            say_sell = {},
            say_sell_nocount = {},
            say_sell_noneed = {},
            say_fix = { "很快的，等我一下。", "这东西好修。", "挺精致的，要修得花点时间。", "等吧，我尽量快点。",
                "真是少见的武器，我得琢磨琢磨。", "要善用武器，不然坏得很快。", "磨损严重，你等会吧。", },
        },
        numerology = {
            say_welcom = { "天算不如人算。", "要我为你占一卦吗？", "请坐吧，想算卦吗？", },
            say_refuse = { "我是瞎子，但是不是傻子。", "天机不可泄露。", },
            say_buy = { "这可是货真价实的狗皮膏药。", "我这可不是地摊货。", "东西都买了，要算卦吗？", },
            say_buy_nocoin = { "我算出你没钱了。", "不给钱会遭天谴。", "我算算，你最近手头很紧对不对？", "没钱就不可知命。", },
            say_buy_nocount = { "卖光咯。", "别买啦，要不让我给你算一卦吧。", "命里无时莫强求。", },
            say_sell = {},
            say_sell_nocount = {},
            say_sell_noneed = {},
            say_treasure = { "凑近点，我告诉你一个小秘密...", "我这有一张藏宝图，给你看看吧。", "别担心，这独家秘密绝没有第三人知道。",
                "客官出手真是阔绰，我就把秘密告诉你吧。", },
            say_treasure_error = { "命里有时终须有，命里无时莫强求。", "不好意思，我弄丢了。", "你等下，我找找看。",
                "有些累，让我歇会。", "别急，我马上就能找到。", },
            say_fate = {
                "这一卦太过凶险，不可述之。", "你没吃早饭吧，还是要对胃好点。", "你有倾心的对象吗。", "今日不宜出远门。",
                "今日宜说\"棒\"！", "小时候我不小心掉进河里，磕到脑袋，从此能识天命知歧路。", "最近你有桃花运哦。",
            },
            say_fate_dog = { "狂犬之袭，{time}天之期！", "疯狗要来了，约{time}天后。", },
            say_fate_bearger = { "尖嘴獠牙，狂兽将于{time}天至！", "巨熊之灾，{time}天之期！", },
            say_fate_deerclops = { "{time}天后，独眼怪物要来了。", "万万小心，{time}天后，鹿角怪将来大肆破坏。", },
            say_fate_season = { "时间过得真快呀，还有{time}天就要换季了。", "美好的季节还剩{time}天咯。", },
            say_fate_moon = { "今晚{time}。", "满盈玉盘还是无月之夜，是{time}。", "月满月亏月乾坤，月缺月盈月阴阳，是为{time}。", },
            say_fate_rain = {
                "万里无云，心情如天气一样晴朗。", "即使多云也不会影响我们的心情。", "阴天，房间要点灯。",
                "乌云密布，记得收衣服。", "山雨欲来风满楼。",
            },
        },
        construct = {
            say_welcom = { "欢迎，搞家装吗？", "欢迎啊，要建点什么？", },
            say_refuse = { "你在做什么！", "别看我呀。", },
            say_buy = { "写得很详细，傻子都能学会。", "都是我熬夜绘制的。", "每一种建筑都有我独到的见解。", "谢谢你的肯定。", },
            say_buy_nocoin = { "一分钱一分货。", "你是不把我放在眼里吗！", "我自己都缺钱。", "生意难做啊。", },
            say_buy_nocount = { "卖光了，只剩我脑子里还有了。", "没了，别催我做新的。", "有印刷术提高我制图效率就好了。", },
            say_sell = {},
            say_sell_nocount = {},
            say_sell_noneed = {},
        },
    },
    MOONSTATE = {
        new           = "新月",
        quarter       = "峨眉月",
        half          = "弦月",
        threequarter  = "凸月",
        full          = "满月",
    },
    CLUE = { "在{address}的地点，{time}时，{weather}，会找到你想要的东西。" },
    CLUEADDRESS = {
        multiplayer_portal = "一元初始",
        pigking = "蛮夷之王所在",
        lava_pond = "烈火熔融",
        oasislake = "风沙掩盖",
        pond = "隔水听蛙",
        pond_mos = "泽国多蚊",
        moonbase = "承接月华",
        critterlab = "精灵顽动",
        beequeenhive = "诸蜂守卫",
        moonland = "月影徘徊",
        myth_ghg = "太阴宫所居",
        fangcunhill = "桃花烂漫",
        hermithouse = "隐士隐居",
        peachtree_myth = "桃花烂漫",
        myth_plant_bamboo = "竹影婆娑",
        myth_shop = "竹影婆娑",
        walrus_camp = "猎牙捕兽",
        wormhole = "颠倒乾坤",
        beefalo = "牦牛舐犊",
        lightninggoat = "膻根群聚",
        deer = "袋匙源头",
        koalefant = "合眼摸象",
        gravestone = "枯骨长眠",
    },
    CLUETIME = {
        "日正当午", --1：白天
        "夕阳渐坠", --2：黄昏
        "夜静阑珊", --3：夜晚
        "满月盈天", --4：满月
        "朔月隐晦", --5：新月
    },
    CLUEWEATHER = {
        "万里无云", --1：晴天
        "阴雨绵绵", --2：雨雪天
    },
    NIANWEIDU = {
        "毫无氛围可言，与平日并无不同",
        "稀疏平常的年味，也许可以称作年吧",
        "已经许久，没有这样热闹的气氛啦",
        "岁岁有今日，年年有今朝",
        "欢天喜地吉祥日，风风火火过大年",
    },
    TAOQIZHI = 
    { "地天泰，小往大来，通泰吉祥", "前方祸福不定，莫要浑浑噩噩", "我观你印堂发黑，怕是要有血光之灾", },
}

STRINGS.USE_MYTH_DELIVER = "传信"

STRINGS.NAMES.PASS_COMMISSIONER = "酆都路引"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PASS_COMMISSIONER = "娑婆苦，死无常，何人敢放荡"

STRINGS.NAMES.PASS_COMMISSIONER_YLW = "酆都路引·阎罗王"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PASS_COMMISSIONER_YLW = "娑婆苦，死无常，何人敢放荡"

STRINGS.NAMES.PASS_COMMISSIONER_WZ = "酆都路引·魏征"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PASS_COMMISSIONER_WZ = "善果，当赏之"

STRINGS.NAMES.PASS_COMMISSIONER_ZK = "酆都路引·钟馗"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PASS_COMMISSIONER_ZK = "恶果，自食之"

STRINGS.NAMES.PASS_COMMISSIONER_CJ = "酆都路引·崔珏"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PASS_COMMISSIONER_CJ = "律令之下，功过自有判"

STRINGS.NAMES.MYTH_HIGANBANA_REBORN = "曼珠沙华"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_HIGANBANA_REBORN = "黄泉边岸多少事？一碗孟婆送白头。"

STRINGS.NAMES.PASS_COMMISSIONER_LZD = "酆都路引·陆之道"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PASS_COMMISSIONER_LZD = {
    GENERIC = "查鉴功过，善恶不可欺",
    INACTIVE = "得先传个口信。", --无常给非激活的路引时触发
    ONLYYAMA = "这不是我能用的。", --非无常角色给予时触发
    NOTSOUL = "这位大人只要善恶魂魄。", --无常给非善恶魂时触发
}

STRINGS.NAMES.PASS_COMMISSIONER_MP = "酆都路引·孟婆"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PASS_COMMISSIONER_MP = "浑浑噩噩，饮汤一碗"

STRINGS.NAMES.MYTH_HOUSE_BAMBOO = "苍竹瓦屋"
STRINGS.RECIPE_DESC.MYTH_HOUSE_BAMBOO = "苍竹碧瓦归何处"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_HOUSE_BAMBOO = "黛瓦碧竹，江南流水"

STRINGS.NAMES.WALL_DWELLING_ITEM = "黑瓦白墙"
STRINGS.RECIPE_DESC.WALL_DWELLING_ITEM = "青瓦人已荒，苍烟起白墙"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WALL_DWELLING_ITEM = "青瓦人已荒，苍烟起白墙"

STRINGS.NAMES.WALL_DWELLING = "黑瓦白墙"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WALL_DWELLING = "青瓦人已荒，苍烟起白墙"

STRINGS.NAMES.FENCE_BAMBOO_ITEM = "竹栅栏"
STRINGS.RECIPE_DESC.FENCE_BAMBOO_ITEM = "竹香悠悠"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FENCE_BAMBOO_ITEM = "小院庭芜绿，凭栏忆往昔"

STRINGS.NAMES.FENCE_BAMBOO = "竹栅栏"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FENCE_BAMBOO = "小院庭芜绿，凭栏忆往昔"

STRINGS.NAMES.FENCE_GATE_BAMBOO_ITEM = "竹门"
STRINGS.RECIPE_DESC.FENCE_GATE_BAMBOO_ITEM = "半掩门扉"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FENCE_GATE_BAMBOO_ITEM = "竹门何设护此身"

STRINGS.NAMES.FENCE_GATE_BAMBOO = "竹门"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FENCE_GATE_BAMBOO = "竹门何设护此身"

STRINGS.NAMES.MYTH_ROCKTIPS = "鹅卵石"
STRINGS.RECIPE_DESC.MYTH_ROCKTIPS = "也许没那么膈脚"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_ROCKTIPS = "崎岖的小路上布满了鹅卵石"

STRINGS.NAMES.MYTH_STOOL = "木凳子"
STRINGS.RECIPE_DESC.MYTH_STOOL = "坐下休息吧"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_STOOL = "可得要好好休息一阵"

STRINGS.NAMES.MYTH_NIAN_FUR = "年兽鬃毛"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_NIAN_FUR = "除夕午夜，扰乱人间"

STRINGS.NAMES.MYTH_NIAN = "年兽"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_NIAN = "金灿如阳的鬃毛"

STRINGS.NAMES.NIAN_MOUNT = "年兽"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NIAN_MOUNT = "你现在温顺多了 "

STRINGS.NAMES.MYTH_NIANHAT = "年兽面具"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_NIANHAT = "兽面遮羞，莫惹烦愁"

STRINGS.NAMES.NIAN_BELL = "年兽铃铛"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NIAN_BELL = "好似有东西在打呼噜"

STRINGS.NAMES.MINIFLARE_MYTH = "窜天猴"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MINIFLARE_MYTH = "爆竹声中一岁除"

STRINGS.NAMES.FIRECRACKERS_MYTH = "爆竹"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FIRECRACKERS_MYTH = "一飞冲天，春到人间"

STRINGS.NAMES.MYTH_FIREESSENSE = "日之精华"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FIREESSENSE = "至刚至阳，凝为此物"

STRINGS.NAMES.MYTH_COLDESSENSE = "月之精华"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_COLDESSENSE = "至柔至阴，化为此形"

STRINGS.NAMES.CANE_PEACH = "桃木手杖"
STRINGS.CHARACTERS.GENERIC.CANE_PEACH = "弃其杖，化为邓林"

STRINGS.NAMES.MYTH_PLANT_INFANTREE_TRUNK = "被推倒的树根"
STRINGS.CHARACTERS.GENERIC.MYTH_PLANT_INFANTREE_TRUNK= "一截枯朽的树根，怕是仙神难救"

STRINGS.NAMES.MYTH_PLANT_INFANTREE_MEDIUM = "复苏仙树"
STRINGS.CHARACTERS.GENERIC.MYTH_PLANT_INFANTREE_MEDIUM = "日月凝聚，枯木逢春"

STRINGS.NAMES.MYTH_PLANT_INFANTREE = "人参果树"
STRINGS.CHARACTERS.GENERIC.MYTH_PLANT_INFANTREE = "仙山松鹤，天开地辟一灵根"

STRINGS.NAMES.MYTH_PLANT_INFANT_FRUIT = "人参果"
STRINGS.CHARACTERS.GENERIC.MYTH_PLANT_INFANT_FRUIT = "如婴似娃，食之长生"

STRINGS.NAMES.MYTH_INFANT_FRUIT = "人参果"
STRINGS.CHARACTERS.GENERIC.MYTH_INFANT_FRUIT = "如婴似娃，食之长生"

STRINGS.NAMES.MYTH_GOLD_STAFF = "金击子"
STRINGS.CHARACTERS.GENERIC.MYTH_GOLD_STAFF = "一条赤金，二尺长短"

STRINGS.NAMES.INFANTREE_CARPET = "人参果地毯"
STRINGS.RECIPE_DESC.INFANTREE_CARPET = "缠根青苔绿"
STRINGS.CHARACTERS.GENERIC.INFANTREE_CARPET = "叶落纷纷，融入此身"

STRINGS.NAMES.COMMISSIONER_BOOK = "判官笔·生死簿"
STRINGS.CHARACTERS.GENERIC.COMMISSIONER_BOOK = "钦定生死，何敢不从？"

STRINGS.NAMES.COMMISSIONER_FLYBOOK = "生死簿"
STRINGS.CHARACTERS.GENERIC.COMMISSIONER_FLYBOOK = "钦定生死，何敢不从？"

STRINGS.NAMES.COMMISSIONER_MPT = "孟婆汤"
STRINGS.CHARACTERS.GENERIC.COMMISSIONER_MPT = "沧浪之水涤清浊"

STRINGS.NAMES.MYTH_PLAYERREDPOUCH_NORMAL = "红包"
STRINGS.CHARACTERS.GENERIC.MYTH_PLAYERREDPOUCH_NORMAL = "喜悦情义最深重，钱财寡少皆喝彩！"

STRINGS.NAMES.MYTH_PLAYERREDPOUCH_SUPER = "好运红包"
STRINGS.CHARACTERS.GENERIC.MYTH_PLAYERREDPOUCH_SUPER = "彩绳穿线过，编织做龙形"

STRINGS.MYTH_YJP_NEEDMAX = "长春虽妙，甘露枯涸"

STRINGS.MYTH_INFANT_FRUIT_ONDROP = {
    GENERIC = "这果子还能被泥巴吃了吗？",
    monkey_king = "俺老孙一时糊涂，忘了这果子习性",
    pigsy = "不会是那泼猴又在耍俺吧",
    neza = "哎，哪吒摘的人参果哪去了",
    white_bone = "这滔天的机缘我是无福可享了",
    yangjian = "师傅曾提过此事 罢了",
    myth_yutu = "啊，我又办砸了，这可怎么办呀",
    yama_commissioners = "这下可坏事了",
    madameweb="糟糕 妾身忘记织网了",
    myth_tudi = "大圣，这可不关小老儿的事",
}

STRINGS.NAMES.PANDAMAN_MYTH = "熊猫村民"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PANDAMAN_MYTH = "流离失所的熊猫村民在重建他们的家园"

STRINGS.NAMES.MYTH_FOOD_THL = "糖葫芦"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_THL = "闻一闻都要流口水了"

STRINGS.NAMES.MYTH_FOOD_NRLM = "牛肉拉面"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_NRLM = "牛味十足，汤香四溢 "

STRINGS.NAMES.MYTH_FOOD_DJYT = "豆浆油条"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_DJYT = "每天都要按时吃早餐哦"

STRINGS.NAMES.MYTH_FOOD_CDF = "臭豆腐"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_CDF = "太香了，只有一点点臭味罢了"

STRINGS.NAMES.MYTH_FOOD_LRHS = "驴肉火烧"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_LRHS = "一个不过，两个太撑 "

STRINGS.NAMES.MYTH_FOOD_LHYX = "莲花血鸭"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_LHYX = "辣到我心坎了"

STRINGS.NAMES.MYTH_FOOD_GQMX = "过桥米线"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_GQMX = "鲜香适宜，我舌头都要咬掉了"

STRINGS.NAMES.MYTH_FOOD_XCMT = "咸菜馒头"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_FOOD_XCMT = "没有比这更下饭的了"

STRINGS.NAMES.TREASURE_PAPER_MYTH = "线索纸"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TREASURE_PAPER_MYTH = ""

STRINGS.PANDAMAN_MYTH_TALKS = {
    "你能帮我修缮一下店铺吗",
    "村庄重建后欢迎你前来做客",
    "村庄被怪物侵袭后很久都没有来客了",
    "你能帮我寻一些建材吗",
    "若是能帮我们重建家园那实在是万分感谢 ",
}

STRINGS.UI.CRAFTING["NEEDSMYTH_TECH_INFANTREE"] = "靠近人参果树制造一个原型！"
STRINGS.UI.CRAFTING["NEEDSMYTH_TECH"] = "使用天书制造一个原型！"
STRINGS.UI.CRAFTING["NEEDSMYTH_TECH_CHANGE_FOUR"] = "需要嫦娥满级好感度制造一个原型！"