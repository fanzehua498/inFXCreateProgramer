angular.module('hotelApp.controllers', [])
    .controller("hotelIndexCtrl", ["$scope", '$location', "$stateParams", "$filter", "hotelIndexService", "commonService", "$window",
        function ($scope, $location, $stateParams, $filter, hotelIndexService, commonService, $window) {
            //*************************验证登录，获取用户信息 begin ****************
            commonService.autoLoginFromParams($stateParams);
            //*************************验证登录，获取用户信息 end   ****************

            //*************************日期 begin ************************
            //入店日期
            var arriveDate = commonService.formatArriveDate();
            if (arriveDate) {
                $("#startDate").html(arriveDate.substring(arriveDate.indexOf('-') + 1, arriveDate.length));
                $("#hid_startDate").val(arriveDate);
            }
            //离店日期
            var departureDate = commonService.formatDepartureDate();
            if (departureDate) {
                $("#endDate").html(departureDate.substring(departureDate.indexOf('-') + 1, departureDate.length));
                $("#hid_endDate").val(departureDate);
            }
            //日期控件
            commonService.initTimePicker(arriveDate, departureDate);
            //弹出日历选择控件
            $scope.showTimeBox = function () {
                $.popup('.popup-about');
            }
            //取消关闭日历空间
            $scope.cancelCanlender = function () {
                commonService.initTimePicker(arriveDate, departureDate);
            }
            //*************************日期 end ************************

            //*************************城市 begin ************************
            //默认城市
            var jsonSearchCondition = "";
            if (localStorage.getItem("SEARCH_CONDITION")) {
                jsonSearchCondition = JSON.parse(localStorage.getItem("SEARCH_CONDITION"));
                if(jsonSearchCondition){
                    $("#span_curCity").html(jsonSearchCondition.CityName);
                    $("#hid_curCity").val(jsonSearchCondition.CityId);
                    $('.cityName').html(jsonSearchCondition.CityName);
                }
            }

            //城市控件字母列导航
            $(".navbar").find("a").click(function () {
                $(".navbar").find("a").removeClass("current")
                $(this).addClass("current")
                var container = $("#province").find(".pro-picker");
                var ids = $(this).html();
                $(".province").find("dt").removeClass("current")
                $('#' + ids).addClass("current")
                scrollTos = $('#' + ids);
                if (scrollTos.length != 0) {
                    container.scrollTop(
                        scrollTos.offset().top - container.offset().top + container.scrollTop()
                    );
                }
            });

            $(".navbar a").on("touchmove touchstart", function (e) {
                e.preventDefault();
                e = e || window.event;
                var touch = e.targetTouches[0];
                var ele = document.elementFromPoint(touch.pageX, touch.pageY);

                var width = $(".navbar").width();
                var height = $(".navbar").height();
                var pos = {
                    "x": touch.pageX,
                    "y": touch.pageY
                };
                var x = pos.x,
                    y = pos.y;
                var offset = $(".navbar").offset();
                var left = offset.left,
                    top = offset.top;
                if (x > left && x < (left + width) && y > top && y < (top + height)) {
                    var container = $("#province").find(".pro-picker");
                    var ids = ele.innerHTML;
                    $(".province").find("dt").removeClass("current")
                    $('#' + ids).addClass("current")
                    scrollTos = $('#' + ids);
                    if (scrollTos.length != 0) {
                        container.scrollTop(
                            scrollTos.offset().top - container.offset().top + container.scrollTop()
                        );
                    }
                };
            });

            $window.locationUpdate = function (x,y) {
                x = x || 39.9;
                y = y || 116.4;
                getCurrentCity(x, y);
                localStorage.setItem('needLocal','1');
            }
            $scope.cityLocation = function () {
                hotelIndexService.location();
            }
            if(JSON.parse(localStorage.getItem('needLocal'))){
                hotelIndexService.location();
            }

            //设置默认城市
            function setDefaultCity() {
                $(".cityName").html("北京");
                $("#span_curCity").html("北京");
                $("#hid_curCity").val("0101");
                //清空筛选
                localStorage.removeItem("ElongCITY_BRAND");
                localStorage.removeItem("H_CITY_BUSINESSZONE");
            }

            //转化经纬度获取城市
            function getCurrentCity(lat, lng) {
                var data = {
                    latitude: lat,
                    longitude: lng
                };
                commonService.getCurrentCity(data).then(function (res) {
                    if (res.ReturnCode == 200) {
                        if(res.Data.FormattedAddress.length >= 12){
                            $("#span_curCity").html(res.Data.FormattedAddress.substring(0,12) + "...");
                        }else{
                            $("#span_curCity").html(res.Data.FormattedAddress);
                        }
                        $(".locationName").html(res.Data.FormattedAddress)
                        $(".cityName").html(res.Data.CityName);
                        $("#hid_curCity").val(res.Data.CityCode);
                        localStorage.setItem("ElongCURRENTCITY", res.Data.CityName);
                    } else {
                        $.toast("获取定位信息失败，请手动选择城市");
                        setDefaultCity();
                    }
                });
            }
            //弹出城市选择框
            $scope.showCityBox = function () {
                $.popup('.popup-city');
                $scope.cityList = null;

                //热门城市
                $scope.hotCityList = [{
                        CityName: "北京",
                        CityCode: "0101"
                    }, {
                        CityName: "上海",
                        CityCode: "0201"
                    },
                    {
                        CityName: "广州",
                        CityCode: "2001"
                    }, {
                        CityName: "深圳",
                        CityCode: "2003"
                    },
                    {
                        CityName: "杭州",
                        CityCode: "1201"
                    },
                    /*{
                        CityName: "艺龙测试",
                        CityCode: "5389"
                    }*/
                ];

                //获取城市
                if (!localStorage.getItem("ElongCITY")) {
                    hotelIndexService.getAllCity({}).then(function (res) {
                        if (res.ReturnCode == 200) {
                            $scope.cityList = res.Data;
                            localStorage.setItem("ElongCITY", JSON.stringify(res.Data));
                        } else {
                            $.toast(res.Message);
                        }
                    });
                } else {
                    $scope.cityList = JSON.parse(localStorage.getItem("ElongCITY"));
                }
            }
            /*城市搜索*/
            $scope.searchCity = [];
            $scope.inputCity = function (city) {
                if(city.length >= 2){
                    hotelIndexService.getCity({"CityName": city}).then(function (res) {
                        if(res.ReturnCode == 200){
                            $scope.searchCity = res.Data;
                        }else{
                            $scope.searchCity = [];
                            $.toast(res.Message);
                        }
                    })
                }else{
                    $scope.searchCity = [];
                }
            }
            $scope.cancel_city = function(){
                $.closeModal('.popup-city');
            }
            //点击选择城市
            $scope.clickCity = function (city) {
                $("#span_curCity").html(city.CityName);
                $("#hid_curCity").val(city.CityCode);
                $(".cityName").html(city.CityName);
                $('.locationName').html('');
                localStorage.setItem("ElongCURRENTCITY", city.CityName);
                this.closeCityBox();

                //更新localstorage
                jsonSearchCondition.CityId = city.CityCode;
                jsonSearchCondition.CityName = city.CityName;
                jsonSearchCondition.QueryText = null;
                localStorage.setItem("SEARCH_CONDITION", JSON.stringify(jsonSearchCondition));

                //清除商圈、品牌
                localStorage.removeItem("ElongCITY_BRAND");
                localStorage.removeItem("H_CITY_BUSINESSZONE");
                localStorage.removeItem("needLocal");
            };
            $('.current_city').click(function () {
                var _location = $(this).children('span').html();
                $('#span_curCity').html(_location);
                $('.locationName').html('');
                $.closeModal('.popup-city');
            });
            //关闭城市选择框
            $scope.closeCityBox = function () {
                $.closeModal('.popup-city');
            }
            //*************************城市 end ************************

            //*************************关键字搜索 begin ************************
            //弹出关键字搜索控件
            $scope.showKeywordBox = function () {
                if (!$("#hid_curCity").val()) {
                    $.toast("请选择城市");
                    return false;
                }
                $.popup('.Keyword_popup');
                //城市id
                var cityId = $("#hid_curCity").val();
                //获取品牌
                getCityBrand(cityId);

            }
            //关闭关键字搜索控件
            $scope.closeKeywordBox = function () {
                $.closeModal('.Keyword_popup');
            }
            //输入关键字
            $scope.inputKeyWord = function (keyword) {
                if ($.trim($("#search").val())) {
                    $("#div_content").hide();
                    $("#div_search_list").show();

                    var params = {
                        cityName: $("#span_curCity").html(),
                        keyWord: $.trim($("#search").val())
                    };
                    commonService.getSuggestPosition(params).then(function (res) {
                        $scope.positionList = res.Data;
                    });
                } else {
                    $("#div_search_list").hide();
                    $("#div_content").show();
                }
            }
            //选择建议地点
            $scope.chooseSuggestPositon = function (position) {
                $("#search").val(position);
                $("#div_keyword").html(position);
                this.closeKeywordBox();
            }
            //确认关键字
            $scope.confrimKeyWord = function () {
                if ($("#search").val() && $.trim($("#search").val()))
                    $("#div_keyword").html($("#search").val());
                this.closeKeywordBox();
            }

            //获取城市品牌
            function getCityBrand(cityId) {
                if (!localStorage.getItem("ElongCITY_BRAND")) {
                    hotelIndexService.getCityBrand(cityId).then(function (res) {
                        if (res.ReturnCode == 200) {
                            $scope.cityBrandList = res.Data;
                            localStorage.setItem("ElongCITY_BRAND", JSON.stringify(res.Data));
                            //获取商圈
                            getBusinessZone(cityId);
                        } else {
                            $.toast(res.Message);
                        }
                    });
                } else {
                    $scope.cityBrandList = JSON.parse(localStorage.getItem("ElongCITY_BRAND"));
                    //获取商圈
                    getBusinessZone(cityId);
                }
            }
            //获取城市商圈
            function getBusinessZone(cityId) {
                if (!localStorage.getItem("H_CITY_BUSINESSZONE")) {
                    var params = {
                        cityId: cityId,
                        districtType: 2
                    };
                    hotelIndexService.getBusinessZone(params).then(function (res) {
                        if (res.ReturnCode == 200) {
                            $scope.cityDistrictList = res.Data;
                            if (res.Data && res.Data != "null")
                                localStorage.setItem("H_CITY_BUSINESSZONE", JSON.stringify(res.Data));
                        } else {
                            $.toast(res.Message);
                        }
                    });
                } else {
                    $scope.cityDistrictList = JSON.parse(localStorage.getItem("H_CITY_BUSINESSZONE"));
                }
            }
            //点击选择商圈
            $scope.clickHotKeyWord = function ($event, value) {
                var obj = $($event.target);
                $(".hotel_hotkeyword").removeClass("on");
                obj.parent("li").addClass("on");
                $("#div_keyword").html(value);
                $('#search').val(value);
                this.closeKeywordBox();
            }
            //点击选择品牌并搜索
            $scope.clickHotKeyWord_brand = function ($event, value) {
                var obj = $($event.target);
                $(".hotel_hotkeyword").removeClass("on");
                obj.parent("li").addClass("on");
                $("#div_keyword").html(value);
                $('#search').val(value);
                this.closeKeywordBox();
            }
            //*************************关键字搜索 end ************************

            //*************************星级价格筛选 begin ************************
            //弹出价格筛选控件
            $scope.showPriceBox = function () {
                $.popup('.price_Key_pop');
            }
            //关闭价格筛选控件
            $scope.closePriceBox = function () {
                $.closeModal('.price_Key_pop');
            }
            //点击选择酒店星级
            $(".hotel_type").on("click", function () {
                var value = $(this).children("span").html();
                if (value == "星级不限") {
                    $(".hotel_type").removeClass("on");
                } else {
                    $("#hotel_type_unlimit").removeClass("on");
                }
                $(this).addClass("on");
            });
            //点击选择酒店价格
            $(".hotel_price").on("click", function () {
                var value = $(this).children("span").html();
                $(".hotel_price").removeClass("on");
                $(this).addClass("on");
            });
            //确定酒店星级和价格
            $scope.confirmPriceAndStarType = function () {
                var str = ""; //星级价格搜索框显现字符串
                var starLevel = []; //选择星级
                var priceScope = ""; //选择价格范围

                //选择的价格
                $(".hotel_price.on").each(function () {
                    str += $(this).children("span").html() + "、";
                    priceScope = $(this).attr("value");
                });
                //选择的星级
                $(".hotel_type.on").each(function () {
                    str += $(this).children("span").html() + "、";
                    if ($(this).val() == 1) {
                        starLevel.push(1);
                        starLevel.push(2);
                    } else {
                        starLevel.push($(this).val());
                    }
                });

                //星级value
                $("#hid_starLevel").val(starLevel.join(","));

                //价格value
                if (priceScope != '0') {
                    if (priceScope.indexOf('-') > 0) {
                        $("#hid_minPrice").val(priceScope.split('-')[0]);
                        $("#hid_maxPrice").val(priceScope.split('-')[1]);
                    } else {
                        $("#hid_minPrice").val(priceScope);
                    }
                }

                //价格星级文本框赋值
                str = str.indexOf("、") > 0 ? str.substring(0, str.length - 1) : str;
                $("#div_type_price").html(str);

                //关闭弹框
                this.closePriceBox();
            }
            //*************************价格筛选相关 end ************************

            //查询
            $scope.searchHotel = function () {
                if (!$("#span_curCity").html() || !$("#hid_curCity").val()) {
                    $.toast("请选择城市");
                    return;
                }
                var params= {
                    ArrivalDate: $("#hid_startDate").val(),
                    DepartureDate: $("#hid_endDate").val(),
                    CityId: $("#hid_curCity").val(),
                    CityName: $("#span_curCity").html(),
                    QueryText: $("#div_keyword").html().indexOf('/') > 0 ? $('.locationName').html() : $("#div_keyword").html(),
                }

                //星级
                if ($("#hid_starLevel").val() && $("#hid_starLevel").val() != "-1")
                    params.StarRate = $("#hid_starLevel").val();
                //价格
                if ($("#hid_minPrice").val())
                    params.LowRate = $("#hid_minPrice").val();
                if ($("#hid_maxPrice").val())
                    params.HighRate = $("#hid_maxPrice").val();

                localStorage.setItem("SEARCH_CONDITION", JSON.stringify(params));
                commonService.gotoPage("hotelList");
            }

            //返回首页
            $scope.backHome = function () {
                if (localStorage.getItem(appconfig.RETURN_BACK_PAGE_KEY)) {
                    window.location.href = "http://www.trip.org";
                } else {
                    window.location.href = "http://www.trip.org";
                }

                localStorage.clear();
            }
            //手机物理返回键处理页面跳转和模态框取消
            $window.appCloseModal = function () {
                if ($('body').has('.modal-in').length > 0) {
                    $.closeModal('.modal-in');
                } else {
                    $scope.backHome();
                }
            }
            if(new Date().getHours() < 6){
                $('#morningArrived').show();
            }else{
                $('#morningArrived').hide();
            }
            var preDay = new Date(new Date().getTime() - 1000 * 60 * 60 *24);
            var month = preDay.getMonth() + 1,day = preDay.getDate();
            $scope.morningArrived = month + "月" + day + "日";
            if (browser.versions.ios || browser.versions.iPhone || browser.versions.iPad) {
                $('.header_hide').hide();
                $('.content_wrap').css('top', 0);
                $('.province').css('paddingTop', 0);
                $('.city_wrap').css('top','2.2rem');
                $('.searchbar_header>.city_up').css('visibility','hidden');
            }
        }
    ])
    .controller("hotelListCtrl", ["$scope", "hotelListService", "commonService", "$window",
        function ($scope, hotelListService, commonService, $window) {
            //查询条件
            var jsonSearchCondition = JSON.parse(localStorage.getItem("SEARCH_CONDITION"));

            //计算评分
            $scope.getHotelScore = function (scoreStr) {
                return commonService.caculateScore(scoreStr);
            };

            //*************************关键字搜索 begin ************************
            //弹出关键字搜索控件
            $scope.showKeywordBox = function () {
                if (!jsonSearchCondition.CityId) {
                    $.toast("请选择城市");
                    return;
                }

                $.popup('.Keyword_popup');
                $("#div_keyword").blur();
                //城市id
                var cityId = jsonSearchCondition.CityId;
                //获取品牌
                getCityBrand(cityId);

            }
            //关闭关键字搜索控件
            $scope.closeKeywordBox = function () {
                $.closeModal('.Keyword_popup');
            }
            //输入关键字
            $scope.inputKeyWord = function (keyword) {
                if ($.trim($("#search").val())) {
                    $("#div_content").hide();
                    $("#div_search_list").show();

                    var params = {
                        cityName: jsonSearchCondition.CityName,
                        keyWord: $.trim($("#search").val())
                    };
                    commonService.getSuggestPosition(params).then(function (res) {
                        if (res.ReturnCode && res.ReturnCode == 200) {
                            $scope.positionList = res.Data;
                        }
                    });
                } else {
                    $("#div_search_list").hide();
                    $("#div_content").show();
                }
            }
            //选择建议地点
            $scope.chooseSuggestPositon = function (position) {
                $("#search").val(position);
                $("#div_keyword").val(position);
                this.closeKeywordBox();
                jsonSearchCondition.QueryText = $("#div_keyword").val();
                reGetHotelList(jsonSearchCondition);
            }

            //获取城市品牌
            function getCityBrand(cityId) {
                if (!localStorage.getItem("ElongCITY_BRAND")) {
                    hotelListService.getCityBrand(cityId).then(function (res) {
                        if (res.ReturnCode == 200) {
                            $scope.cityBrandList = res.Data;
                            localStorage.setItem("ElongCITY_BRAND", JSON.stringify(res.Data));
                            //获取商圈
                            getBusinessZoneList(cityId);
                        } else {
                            $.toast(res.Message);
                        }
                    });
                } else {
                    $scope.cityBrandList = JSON.parse(localStorage.getItem("ElongCITY_BRAND"));
                    //获取商圈
                    getBusinessZoneList(cityId);
                }
            }
            //获取城市商圈
            function getBusinessZoneList(cityId) {
                if (!localStorage.getItem("H_CITY_BUSINESSZONE")) {
                    var params = {
                        cityId: cityId,
                        districtType: 2
                    };
                    hotelListService.getBusinessZone(params).then(function (res) {
                        if (res.ReturnCode == 200) {
                            $scope.cityDistrictList = res.Data;
                            if (res.Data && res.Data != "null")
                                localStorage.setItem("H_CITY_BUSINESSZONE", JSON.stringify(res.Data));
                        } else {
                            $.toast(res.Message);
                        }
                    });
                } else {
                    $scope.cityDistrictList = JSON.parse(localStorage.getItem("H_CITY_BUSINESSZONE"));
                }
            }
            //点击选择商圈/品牌
            $scope.clickHotKeyWord = function ($event, value) {
                var obj = $($event.target);
                $(".hotel_hotkeyword").removeClass("on");
                obj.parent("li").addClass("on");
                $("#search").val(value);
                $("#div_keyword").val(value);
                this.closeKeywordBox();
            }

            //确认关键字并搜索
            $scope.confrimKeyWord = function () {
                $("#div_keyword").val($("#search").val());
                this.closeKeywordBox();
                jsonSearchCondition.QueryText = $("#div_keyword").val();
                reGetHotelList(jsonSearchCondition);
            }
            //关键字搜索
            $scope.searchHotel = function () {
                //重新查询
                jsonSearchCondition.QueryText = $("#div_keyword").val();
                reGetHotelList(jsonSearchCondition);
            }
            //*************************关键字搜索 end ************************

            //#region 列表
            //首次查询酒店列表
            $scope.hotelList = [];
            jsonSearchCondition.PageIndex = 1;
            jsonSearchCondition.PageSize = 10;

            //获取酒店列表
            var tempImgUrl = "";

            function getHotelList() {
                hotelListService.getHotelList(jsonSearchCondition).then(function (res) {
                    if (200 == res.ReturnCode && res.Data && res.Data.Hotels) {
                        var count = res.Data.Hotels.length;
                        for (var i = 0; i < count; i++) {
                            tempImgUrl = res.Data.Hotels[i].Detail.ThumbNailUrl;
                            if (tempImgUrl && tempImgUrl.indexOf('https') >= 0)
                                res.Data.Hotels[i].Detail.ThumbNailUrl = tempImgUrl.replace("https", appconfig.WEB_HOST);
                            res.Data.Hotels[i].LowRate = Math.round(res.Data.Hotels[i].LowRate);
                            if(res.Data.Hotels[i].LowRate == 0){
                                res.Data.Hotels[i].LowRate = "满房";
                            }
                            $scope.hotelList.push(res.Data.Hotels[i]);
                        }
                        if (count < 10) {
                            jsonSearchCondition.PageIndex++;
                            $('.infinite-scroll-preloader').hide();
                        } else {
                            $('.infinite-scroll-preloader').show();
                            jsonSearchCondition.PageIndex++;
                        }
                    } else {
                        $.detachInfiniteScroll($('.infinite-scroll'));
                        $('.infinite-scroll-preloader').remove();
                        $.toast("没有更多了");
                        return;
                    }
                });
            }

            //改变查询条件，重新查询酒店列表
            function reGetHotelList(jsonSearchCondition) {
                jsonSearchCondition.PageIndex = 1;
                //jsonSearchCondition.QueryText = $("#div_keyword").val();
                //jsonSearchCondition.BrandId = "";
                if (jsonSearchCondition.QueryText)
                    $("#div_keyword").val(jsonSearchCondition.QueryText);

                $scope.hotelList = [];
                localStorage.setItem("SEARCH_CONDITION", JSON.stringify(jsonSearchCondition));
                hotelListService.getHotelList(jsonSearchCondition).then(function (res) {
                    if (200 == res.ReturnCode && res.Data && res.Data.Hotels) {
                        var count = res.Data.Hotels.length;
                        for (var i = 0; i < count; i++) {
                            tempImgUrl = res.Data.Hotels[i].Detail.ThumbNailUrl;
                            if (tempImgUrl && tempImgUrl.indexOf('https') >= 0)
                                res.Data.Hotels[i].Detail.ThumbNailUrl = tempImgUrl.replace("https", appconfig.WEB_HOST);
                            res.Data.Hotels[i].LowRate = Math.round(res.Data.Hotels[i].LowRate);
                            if(res.Data.Hotels[i].LowRate == 0){
                                res.Data.Hotels[i].LowRate = "满房";
                            }
                            $scope.hotelList.push(res.Data.Hotels[i]);
                        }
                        if (count < 10) {
                            $('.infinite-scroll-preloader').hide();
                        } else {
                            $('.infinite-scroll-preloader').show();
                            jsonSearchCondition.PageIndex++;
                        }
                    } else {
                        $.detachInfiniteScroll($('.infinite-scroll'));
                        $('.infinite-scroll-preloader').remove();
                        $.toast("没有更多了");
                        return;
                    }
                });
            }

            //滑动加载更多数据
            $(document).on("pageInit", "#page-infinite-scroll-bottom", function (e, id, page) {
                var loading = false;
                getHotelList();

                $(page).on('infinite', function () {
                    // 如果正在加载，则退出
                    if (loading) return;
                    // 设置flag
                    loading = true;
                    // 模拟1s的加载过程
                    setTimeout(function () {
                        // 重置加载flag
                        loading = false;

                        getHotelList();
                        $.refreshScroller();
                    }, 1000);
                });
            });
            $.init();
            //#endregion

            //#region 1.筛选 品牌/服务/早餐
            //获取城市所有品牌
            function getAllCityBrand() {
                var cityId = jsonSearchCondition.CityId;
                if (!localStorage.getItem("H_CITY_BRAND_LIST" + cityId)) {
                    var params = {
                        cityId: cityId
                    };
                    hotelListService.getAllBrandByCity(params).then(function (res) {
                        if (res.ReturnCode == 200) {
                            localStorage.setItem("H_CITY_BRAND_LIST" + cityId, JSON.stringify(res.Data));
                            $scope.cityBrandList1 = res.Data;
                            $scope.cityBrandList2 = res.Data;
                            $scope.cityBrandList3 = res.Data;
                            $scope.cityBrandList4 = res.Data;
                        } else {
                            $.toast(res.Message);
                        }
                    });
                } else {
                    $scope.cityBrandList1 = JSON.parse(localStorage.getItem("H_CITY_BRAND_LIST" + cityId));
                    $scope.cityBrandList2 = JSON.parse(localStorage.getItem("H_CITY_BRAND_LIST" + cityId));
                    $scope.cityBrandList3 = JSON.parse(localStorage.getItem("H_CITY_BRAND_LIST" + cityId));
                    $scope.cityBrandList4 = JSON.parse(localStorage.getItem("H_CITY_BRAND_LIST" + cityId));
                }
            }
            //filter 过滤品牌类型
            $scope.brandFilter = function (brand) {
                return brand.Category < 3;
            }
            //打开筛选box
            $scope.showFilterBox = function () {
                $.popup('.popup-about');
                if (!$scope.cityBrandList1)
                    getAllCityBrand();
            }

            //选择筛选标签
            $("#left_hotel_nav").find("li").click(function () {
                $("#left_hotel_nav").find("li").removeClass("on");
                $(this).addClass("on");
                $("#left_hotel_ct").find(".keyword-box-list").hide();
                $("#left_hotel_ct").find(".keyword-box-list").eq($(this).index()).show();
            });
            //选择品牌
            var chosenBrandId = '';
            $scope.chooseBrand = function (event) {
                $("#div_brand_list").find("li").removeClass("on");
                $(event.target).parent("li").addClass("on");
                chosenBrandId = $(event.target).attr("attr-id");
            }
            //选择设施
            $("#div_facilities").find("li").on("click", function () {
                if ($(this).attr("attr-id") < 0) {
                    $("#div_facilities").find("li").removeClass("on");
                    $(this).toggleClass("on");
                } else {
                    $(".unlimit").removeClass("on");
                    $(this).toggleClass("on");
                    if ($("#div_facilities").find("li.on").length > 3) {
                        $.toast("最多选3个");
                        $(this).removeClass("on");
                    }
                }
            });
            //选择主题
            $("#div_themes").find("li").on("click", function () {
                if ($(this).attr("attr-id") < 0) {
                    $("#div_themes").find("li").removeClass("on");
                    $(this).toggleClass("on");
                } else {
                    $(".unlimit").removeClass("on");
                    $(this).toggleClass("on");
                    if ($("#div_themes").find("li.on").length > 3) {
                        $.toast("最多选3个");
                        $(this).removeClass("on");
                    }
                }
            });

            //关闭筛选box
            $scope.closeFilterBox = function () {
                $.closeModal('.popup-about');
            }
            //确认筛选
            $scope.confirmFilter = function () {
                $.closeModal('.popup-about');
                //1.品牌筛选
                if (chosenBrandId && chosenBrandId > 0)
                    jsonSearchCondition.BrandId = chosenBrandId;
                else
                    jsonSearchCondition.BrandId = '';
                //2.设施筛选
                var chosenFacilitiesIds = '';
                $("#div_facilities").find("li.on").each(function () {
                    if ($(this).attr("attr-id") > 0)
                        chosenFacilitiesIds += $(this).attr("attr-id") + ",";
                });
                chosenFacilitiesIds = chosenFacilitiesIds.substring(0, chosenFacilitiesIds.length - 1);

                if (chosenFacilitiesIds && chosenFacilitiesIds.length > 0) {
                    jsonSearchCondition.Facilities = chosenFacilitiesIds;
                } else {
                    jsonSearchCondition.Facilities = '';
                }
                //3.主题筛选
                var chosenThemesIds = '';
                $("#div_themes").find("li.on").each(function () {
                    if ($(this).attr("attr-id") > 0)
                        chosenThemesIds += $(this).attr("attr-id") + ",";
                });
                chosenThemesIds = chosenThemesIds.substring(0, chosenThemesIds.length - 1);
                if (chosenThemesIds && chosenThemesIds.length > 0) {
                    jsonSearchCondition.ThemeIds = chosenThemesIds;
                } else {
                    jsonSearchCondition.ThemeIds = '';
                }
                //查询
                reGetHotelList(jsonSearchCondition);
            }
            //#endregion

            //#region 2.区域位置
            //打开区域位置Box
            $scope.showDistrictBox = function () {
                $.popup('.popup-region');
                //获取商圈
                getBusinessZone();
            }

            //获取商圈
            function getBusinessZone() {
                var cityId = jsonSearchCondition.CityId;
                if (!localStorage.getItem("H_CITY_BUSINESSZONE" + cityId)) {
                    var params = {
                        cityId: cityId,
                        districtType: 2
                    };
                    hotelListService.getCityDistrict(params).then(function (res) {
                        if (res.ReturnCode == 200) {
                            localStorage.setItem("H_CITY_BUSINESSZONE" + cityId, JSON.stringify(res.Data));
                            $scope.businessZone = res.Data;
                            //获取行政区
                            getDistrictList();
                        } else {
                            $.toast(res.Message);
                        }
                    });
                } else {
                    $scope.businessZone = JSON.parse(localStorage.getItem("H_CITY_BUSINESSZONE" + cityId));
                    //获取行政区
                    getDistrictList();
                }
            }
            //行政区
            function getDistrictList() {
                var cityId = jsonSearchCondition.CityId;
                if (!localStorage.getItem("H_CITY_DISTRICT" + cityId)) {
                    var params = {
                        cityId: cityId,
                        districtType: 1
                    };
                    hotelListService.getCityDistrict(params).then(function (res) {
                        if (res.ReturnCode == 200) {
                            localStorage.setItem("H_CITY_DISTRICT" + cityId, JSON.stringify(res.Data));
                            $scope.districtList = res.Data;
                            //地标建筑
                            getBuildingList();
                        } else {
                            $.toast(res.Message);
                        }
                    });
                } else {
                    $scope.districtList = JSON.parse(localStorage.getItem("H_CITY_DISTRICT" + cityId));
                    //地标建筑
                    getBuildingList();
                }
            }
            //标志建筑
            function getBuildingList() {
                var cityId = jsonSearchCondition.CityId;
                if (!localStorage.getItem("H_CITY_BUILDING" + cityId)) {
                    var params = {
                        cityId: cityId,
                        districtType: 3
                    };
                    hotelListService.getCityDistrict(params).then(function (res) {
                        if (res.ReturnCode == 200) {
                            localStorage.setItem("H_CITY_BUILDING" + cityId, JSON.stringify(res.Data));
                            $scope.buildingList = res.Data;
                        } else {
                            $.toast(res.Message);
                        }
                    });
                } else {
                    $scope.buildingList = JSON.parse(localStorage.getItem("H_CITY_BUILDING" + cityId));
                }
            }

            //选择区域标签
            $("#left_hotel_nav2").find("li").click(function () {
                $("#left_hotel_nav2").find("li").removeClass("on");
                $(this).addClass("on");
                $("#left_hotel_ct2").find(".list-block").hide()
                $("#left_hotel_ct2").find(".list-block").eq($(this).index()).show()
            });

            var chosenDistrictName = ""; //选中区域名称
            //选择商圈
            $scope.chooseZone = function (event) {
                $("#left_hotel_ct2").find("li").removeClass("on");
                $(event.target).addClass("on");
                chosenDistrictName = $(event.target).html();
            }
            //选择行政区
            $scope.chooseDistrict = function (event) {
                $("#left_hotel_ct2").find("li").removeClass("on");
                $(event.target).addClass("on");
                chosenDistrictName = $(event.target).html();
            }
            //选择地标建筑
            $scope.chooseBuilding = function (event) {
                $("#left_hotel_ct2").find("li").removeClass("on");
                $(event.target).addClass("on");
                chosenDistrictName = $(event.target).html();
            }

            //关闭区域位置
            $scope.closeDistrictBox = function () {
                $.closeModal('.popup-region');
            }
            //确认区域位置
            $scope.confirmDistrict = function () {
                $.closeModal('.popup-region');

                if (chosenDistrictName && chosenDistrictName != '不限') {
                    jsonSearchCondition.QueryText = chosenDistrictName;
                    reGetHotelList(jsonSearchCondition);
                } else {
                    jsonSearchCondition.QueryText = '';
                    reGetHotelList(jsonSearchCondition);
                }
            }
            //#endregion

            //#region 3.星级价格
            //打开星级价格Box
            $scope.showStarPriceBox = function () {
                $.popup('.price_Key_pop');
            }
            //关闭星级价格Box
            $scope.closePriceBox = function () {
                $.closeModal('.price_Key_pop');
            }
            //点击选择酒店星级
            $(".hotel_type").on("click", function () {
                var value = $(this).children("span").html();
                if (value == "星级不限") {
                    $(".hotel_type").removeClass("on");
                } else {
                    $("#hotel_type_unlimit").removeClass("on");
                }
                $(this).addClass("on");
            });
            //点击选择酒店价格
            $(".hotel_price").on("click", function () {
                var value = $(this).children("span").html();
                $(".hotel_price").removeClass("on");
                $(this).addClass("on");
            });
            //确定酒店星级和价格
            $scope.confirmPriceAndStarType = function () {
                var str = ""; //星级价格搜索框显现字符串
                var starLevel = ""; //选择星级
                var priceScope = ""; //选择价格范围

                //选择的价格
                $(".hotel_price.on").each(function () {
                    str += $(this).children("span").html() + "、";
                    priceScope = $(this).attr("value");
                });
                //选择的星级
                $(".hotel_type.on").each(function () {
                    str += $(this).children("span").html() + "、";
                    starLevel += $(this).val() + ","
                });

                //星级value
                $("#hid_starLevel").val(starLevel.substring(0, starLevel.length - 1));

                //价格value
                if (priceScope != '0') {
                    if (priceScope.indexOf('-') > 0) {
                        $("#hid_minPrice").val(priceScope.split('-')[0]);
                        $("#hid_maxPrice").val(priceScope.split('-')[1]);
                    } else {
                        $("#hid_minPrice").val(priceScope);
                    }
                }

                //关闭弹框
                $.closeModal('.price_Key_pop');

                //重新搜索
                //星级
                if ($("#hid_starLevel").val())
                    jsonSearchCondition.StarRate = $("#hid_starLevel").val();
                //价格
                if ($("#hid_minPrice").val())
                    jsonSearchCondition.LowRate = $("#hid_minPrice").val();
                if ($("#hid_maxPrice").val())
                    jsonSearchCondition.HighRate = $("#hid_maxPrice").val();
                reGetHotelList(jsonSearchCondition);
            }
            //#endregion

            //#region 4.排序
            $("#sort").on("click", function () {
                var $thisHml = $(this).find("span");

                $.modal({
                    title: '排序',
                    verticalButtons: true,
                    buttons: [{
                            text: '默认',
                            onClick: function () {
                                $thisHml.html("排序");
                                jsonSearchCondition.Sort = "Default";
                                reGetHotelList(jsonSearchCondition);
                            }
                        },
                        {
                            text: '星级 高-低',
                            onClick: function () {
                                $thisHml.html("推荐星级 高-低");
                                jsonSearchCondition.Sort = "StarRankDesc";
                                reGetHotelList(jsonSearchCondition);
                            }
                        },
                        {
                            text: '价格 低-高',
                            onClick: function () {
                                $thisHml.html("价格 低-高");
                                jsonSearchCondition.Sort = "RateAsc";
                                reGetHotelList(jsonSearchCondition);
                            }
                        },
                        {
                            text: '价格 高-低',
                            onClick: function () {
                                $thisHml.html("价格 高-低");
                                jsonSearchCondition.Sort = "RateDesc";
                                reGetHotelList(jsonSearchCondition);
                            }
                        }
                    ]
                });
            });
            //#endregion

            //返回首页
            $scope.backToIndex = function () {
                jsonSearchCondition.PageIndex = 1;
                $(document).off("pageInit", "#page-infinite-scroll-bottom");
                localStorage.removeItem("HOTEL_LIST_REFRESH");

                var userId = localStorage.getItem(appconfig.USER_ID);
                var token = localStorage.getItem(appconfig.ACESS_TOKEN_KEY);
                if (userId && token) {
                    commonService.gotoPage("hotelIndex", {
                        userId: userId,
                        Token: token
                    });
                }else{
                    $.toast("登录状态丢失，请退出重新登录");
                }
            }
            //手机物理返回键处理页面跳转和模态框取消
            $window.appCloseModal = function () {
                if ($('body').has('.modal-in').length > 0) {
                    $.closeModal('.modal-in');
                } else {
                    $scope.backToIndex();
                }
            }
            //跳转到详情
            $scope.showDetail = function (hotel) {
                if(hotel.LowRate == '满房'){
                    $.toast('此房不可预订或满房');
                    return false;
                }
                jsonSearchCondition.PageIndex = 1;
                $(document).off("pageInit", "#page-infinite-scroll-bottom");

                commonService.gotoPage("hotelDetail", {
                    hotelId: hotel.HotelId
                });
            }
            if (browser.versions.ios || browser.versions.iPhone || browser.versions.iPad) {
                $('.list_header').hide();
                $('.header-sear').css('top', 0);
                $('.list_wrap').css('paddingTop', 0);
            }
        }
    ])
    .controller("hotelDetailCtrl", ["$scope", "$stateParams", "hotelDetailService", "commonService", "$window",
        function ($scope, $stateParams, hotelDetailService, commonService, $window) {
            //region 查询参数
            var jsonSearchCondition = JSON.parse(localStorage.getItem("SEARCH_CONDITION"));
            var params = {
                hotelId: $stateParams.hotelId,
                arriveDate: jsonSearchCondition.ArrivalDate,
                departureDate: jsonSearchCondition.DepartureDate
            }
            getHotelInfoFromApi(params);
            //endregion

            //region 日期相关
            //日期控件
            commonService.initTimePicker(params.arriveDate, params.departureDate);
            //入店日期
            var arriveDate = commonService.formatArriveDate(params.arriveDate);
            if (arriveDate) {
                $scope.ng_arrive_date = arriveDate.substring(arriveDate.indexOf('-') + 1, arriveDate.length);
                $scope.ng_full_arrive_date = arriveDate;
            }
            //离店日期
            var departureDate = commonService.formatDepartureDate(params.departureDate);
            if (departureDate) {
                $scope.ng_departure_date = departureDate.substring(departureDate.indexOf('-') + 1, departureDate.length);
                $scope.ng_full_departure_date = departureDate;
            }
            //计算入店/离店日期相差几天
            $scope.ng_day_diff = commonService.calculateDateDiff(departureDate, arriveDate);
            //弹出日历选择控件
            $scope.showTimeBox = function () {
                $.popup('.popup-about');
            }

            //点击确定
            $scope.resetDate = function () {
                var params = {
                    hotelId: $stateParams.hotelId,
                    arriveDate: $("#hid_startDate").val(),
                    departureDate: $("#hid_endDate").val()
                }
                getHotelInfoFromApi(params);
            }
            //取消关闭日历空间
            $scope.cancelCanlender = function () {
                commonService.initTimePicker(arriveDate, departureDate);
            }
            //endregion

            //region 酒店详情
            function getHotelInfoFromApi(params) {
                //更新搜索条件
                jsonSearchCondition.ArrivalDate = params.arriveDate;
                jsonSearchCondition.DepartureDate = params.departureDate;
                localStorage.setItem("SEARCH_CONDITION", JSON.stringify(jsonSearchCondition));
                //接口获取酒店详情
                hotelDetailService.getHotelDetail(params).then(function (res) {
                    if (res.ReturnCode == 200) {
                        //房型图片url http -> https
                        if (res.Data.Hotels[0].Rooms) {
                            var tempRoomImg = "";
                            for (var i = 0, count = res.Data.Hotels[0].Rooms.length; i < count; i++) {
                                tempRoomImg = res.Data.Hotels[0].Rooms[i].ImageUrl;
                                if (tempRoomImg && tempRoomImg.indexOf("https") >= 0)
                                    res.Data.Hotels[0].Rooms[i].ImageUrl = tempRoomImg.replace("https", appconfig.WEB_HOST);
                            }
                        }
                        $scope.hotelDetail = res.Data.Hotels;
                        localStorage.setItem("PRE_PAY_RULES", JSON.stringify(res.Data.Hotels[0].PrepayRules));
                        localStorage.setItem("VALUE_ADDS", JSON.stringify(res.Data.Hotels[0].ValueAdds));
                        var hotelDetail = res.Data.Hotels[0].Detail;

                        getHotelInfoFromDb(hotelDetail);
                    }
                });
            }
            //数据库酒店信息
            function getHotelInfoFromDb(hotelDetail) {
                hotelDetailService.getHotelInfo({
                    hotelId: $stateParams.hotelId
                }).then(function (res) {
                    if (res.ReturnCode == 200) { //数据库获取信息
                        $scope.hotelInfo = res.Data.HotelDetail;
                        //酒店图片
                        $scope.hotelImgList = [];
                        var tempImgUrl = "";
                        if (res.Data.HotelImageList) {
                            for (var i = 0, count = res.Data.HotelImageList.length; i < count; i++) {
                                tempImgUrl = res.Data.HotelImageList[i].Location;
                                if (tempImgUrl && tempImgUrl.indexOf('https') >= 0)
                                    tempImgUrl = tempImgUrl.replace("https", appconfig.WEB_HOST);
                                $scope.hotelImgList.push(tempImgUrl);
                            }
                        }

                        //酒店电话
                        $scope.hotelPhone = res.Data.HotelDetail.Phone || '000';

                        //酒店简介
                        $scope.hotelDescription = "";
                        if (res.Data.HotelDetail.IntroEditor && res.Data.HotelDetail.IntroEditor != 'null')
                            $scope.hotelDescription = res.Data.HotelDetail.IntroEditor;
                        if (res.Data.HotelDetail.Description && res.Data.HotelDetail.Description != 'null')
                            $scope.hotelDescription += "    " + res.Data.HotelDetail.Description;
                        //酒店设施
                        if (res.Data.HotelDetail.GeneralAmenities)
                            $scope.facilities = res.Data.HotelDetail.GeneralAmenities.split('、');
                    } else if (hotelDetail) { //数据库未查询到酒店信息，选用接口数据
                        //酒店特色
                        $scope.hotelFeatures = hotelDetail.Features;
                        //酒店图片
                        $scope.hotelImgList = [];
                        var tempImgUrl = hotelDetail.ThumbNailUrl;
                        if (tempImgUrl && tempImgUrl.indexOf('https') >= 0)
                            tempImgUrl = tempImgUrl.replace("https", appconfig.WEB_HOST);
                        $scope.hotelImgList.push({
                            Location: tempImgUrl || "../../img/hotel.png"
                        });
                        //房型图片url http -> https
                        if (hotelDetail && hotelDetail.Rooms) {
                            var tempRoomImg = "";
                            for (var i = 0, count = hotelDetail.Rooms.length; i < count; i++) {
                                tempRoomImg = hotelDetail.Rooms[i].ImageUrl;
                                if (tempRoomImg && tempRoomImg.indexOf("https") >= 0)
                                    hotelDetail.Rooms[i].ImageUrl = tempRoomImg.replace("https", appconfig.WEB_HOST);
                            }
                        }

                        //酒店电话
                        $scope.hotelPhone = hotelDetail.Phone;
                        //酒店简介
                        $scope.hotelDescription = hotelDetail.Features;
                        //酒店设施
                        if (hotelDetail.GeneralAmenities)
                            $scope.facilities = hotelDetail.GeneralAmenities.split(',');
                    }
                });
            }

            //监听ng-repeat 完成后执行图片轮播
            $scope.$on('ngRepeatFinished', function (ngRepeatFinishedEvent) {
                $(".swiper-container").swiper();
                if (browser.versions.ios || browser.versions.iPhone || browser.versions.iPad) {
                    $('.content_wrap').css('top', 0);
                }
            });

            //计算评分
            $scope.getHotelScore = function (scoreStr) {
                return commonService.caculateScore(scoreStr);
            };
            //取房型最低价
            $scope.filterPrice = function (room) {
                var rates = room.RatePlans;
                var lowPrice = 0;
                for (var i = 0, length = rates.length; i < length; i++) {
                    if (lowPrice == 0) {
                        lowPrice = rates[i].AverageRate
                    } else {
                        lowPrice = parseFloat(rates[i].AverageRate) - parseFloat(lowPrice) > 0 ? lowPrice : rates[i].AverageRate;
                    }
                }

                return lowPrice;
            }
            //取房型的取消规则
            $scope.filterRule = function(ruleId){
                var _PrepayRules = JSON.parse(localStorage.getItem("PRE_PAY_RULES"));
                var _str_msg = "";
                _PrepayRules.forEach(function (value) {
                    if(value.PrepayRuleId == ruleId ){
                        if(value.ChangeRule == 0){
                            _str_msg = "不可取消";
                        }else{
                            _str_msg = "免费取消";
                        }
                    }
                })
                return _str_msg;
            }
            //附加规则
            $scope.filterAdd = function(addId){
                var _ValueAdds = JSON.parse(localStorage.getItem("VALUE_ADDS"));
                var _str_msg = "";
                _ValueAdds.forEach(function (value) {
                    if(value.ValueAddId == addId){
                        _str_msg = value.Description;
                    }
                })
                return _str_msg;
            }

            //region 预订房间
            $scope.toReserve = function (hotel, room, ratePlan, hotelId) {
                //取出房间对应的担保规则
                var rules = $.grep(hotel.GuaranteeRules, function (value) {
                    return value.GuranteeRuleId == ratePlan.GuaranteeRuleIds;
                });
                var args = {
                    hotelId: hotelId,
                    hotelName: hotel.Detail.HotelName,
                    hotelCode: ratePlan.HotelCode,
                    roomId: room.RoomId,
                    roomName: room.Name,
                    roomDescription: room.Description,
                    roomTypeId: ratePlan.RoomTypeId,
                    ratePlanId: ratePlan.RatePlanId,
                    paymentType: ratePlan.PaymentType,
                    ratePlanName: ratePlan.RatePlanName,
                    arriveDate: $("#hid_startDate").val(),
                    departureDate: $("#hid_endDate").val(),
                    dayCount: $("#hid_dayCount").val() || 1,
                    roomPrice: ratePlan.AverageRate,
                    guaranteeRule: rules.length > 0 ? rules[0] : null,
                    Phone: hotel.Detail.Phone,
                    InvoiceMode: ratePlan.InvoiceMode
                }

                localStorage.setItem("HOTEL_ROOM_INFOMATION_FOR_RESERVATION", JSON.stringify(args));
                commonService.gotoPage("hotelOrder");
            }
            //endregion

            //切换TAb
            $scope.switchTab = function (event) {
                $(".tab-link").removeClass("active");
                $(event.target).addClass("active");
                if (1 == $(event.target).attr("attr-value")) {
                    $(".hotel_detail").show();
                    $(".hotel_introduction").hide();
                } else {
                    $(".hotel_detail").hide();
                    $(".hotel_introduction").show();
                }
            }
            //跳转回
            $scope.backToHotelList = function () {
                commonService.gotoPage("hotelList");
            }
            //手机物理键处理跳转页面和模态框取消
            $window.appCloseModal = function () {
                if ($('body').has('.modal-in').length > 0) {
                    $.closeModal('.modal-in');
                } else {
                    $scope.backToHotelList();
                }
            }
            if (browser.versions.ios || browser.versions.iPhone || browser.versions.iPad) {
                $('.header_hide').hide();
            }
        }
    ])
    .controller("orderCtrl", ["$scope", "$stateParams", "orderService", "commonService", "$window",
        function ($scope, $stateParams, orderService, commonService, $window) {
            //酒店详情页面带入参数 页面控件赋值
            var jsonRoomInfo = JSON.parse(localStorage.getItem("HOTEL_ROOM_INFOMATION_FOR_RESERVATION"));
            $scope.hotel_name = jsonRoomInfo.hotelName;//酒店名称
            $scope.room_name = jsonRoomInfo.roomName;//房间名称
            $scope.room_arriveDate = jsonRoomInfo.arriveDate;//入住日期
            $scope.room_departureDate = jsonRoomInfo.departureDate;//离店日期
            $scope.room_dayCount = jsonRoomInfo.dayCount;//入住时长
            $scope.room_description = jsonRoomInfo.roomDescription + " " + jsonRoomInfo.ratePlanName;//房间描述
            $scope.order_amount = "￥" + Math.round(jsonRoomInfo.roomPrice * jsonRoomInfo.dayCount);//总价
            $scope.hotelPhone = jsonRoomInfo.Phone || '000';//酒店电话
            $scope.InvoiceMode = jsonRoomInfo.InvoiceMode;//酒店能否开具发票
            $scope.isNeedInvoice = "不需要发票";
            var date = new Date(),
                date_timeStamp = date.getTime(), //获取当前时间的时间戳
                guaranteeRule = jsonRoomInfo.guaranteeRule, //获取当前酒店的信用卡担保信息
                hour = date.getHours(),
                NeedGuarantee = false,//后台信用卡担保要用
                isMorningArrivalTime = false; //凌晨入住
            var startDate_timeStamp, endDate_timeStamp, inGuaranteeTime;

            /*凌晨入住判断*/
            if(hour < 6){
                if(jsonRoomInfo.arriveDate == orderService.formatArriveDate(new Date(new Date().getTime() - 1000 * 60 * 60 * 24))){
                    isMorningArrivalTime = true;
                    $('.morning_order').show();
                }else{
                    isMorningArrivalTime = false;
                    $('.morning_order').hide();
                }
            }else if(hour >= 23){
                if(jsonRoomInfo.arriveDate == orderService.formatArriveDate(new Date(new Date().getTime()))){
                    isMorningArrivalTime = true;
                    $('.morning_order').show();
                }else{
                    isMorningArrivalTime = false;
                    $('.morning_order').hide();
                }
            }else{
                isMorningArrivalTime = false;
                $('.morning_order').hide();
            }

            /*当前酒店的信用卡担保信息*/
            if (guaranteeRule != null) {
                startDate_timeStamp = new Date(guaranteeRule.StartDate).getTime(); //开始日期转时间戳
                endDate_timeStamp = new Date(guaranteeRule.EndDate).getTime(); //结束日期转时间戳

                if (startDate_timeStamp == endDate_timeStamp) {
                    inGuaranteeTime = date_timeStamp >= startDate_timeStamp; //当前时间是否在担保日期之间
                } else {
                    inGuaranteeTime = date_timeStamp >= startDate_timeStamp && date_timeStamp <= endDate_timeStamp; //当前时间是否在担保日期之间
                }
                if (guaranteeRule.EndTime.length == 4) {
                    guaranteeRule.EndTime = "0" + guaranteeRule.EndTime;
                }
                var week = date.getDay();
                if (week == 0) week = 7;
                if (guaranteeRule.WeekSet.indexOf(week) > 0) {
                    if (inGuaranteeTime && !guaranteeRule.IsTimeGuarantee && !guaranteeRule.IsAmountGuarantee) {
                        $scope.card_guarantee = guaranteeRule.Description;
                        $('.card_guarantee').show();
                        $("#div_creditcard").show();
                        NeedGuarantee = true;
                    }
                }
            }
            //登录会员信息
            //var userInfo = JSON.parse(localStorage.getItem(appconfig.USER_INFO_KEY));
            //发票信息判断
            var IsNeedInvoice = localStorage.getItem('IsNeedInvoice') ? JSON.parse(localStorage.getItem('IsNeedInvoice')) : false;//是否需要发票
            if(IsNeedInvoice){
                var Invoice = JSON.parse(localStorage.getItem('INVOICE'));
                $scope.isNeedInvoice = Invoice.Title + " " + Invoice.ITIN + " 邮费到付";
            }

            //关闭重复订单
            $scope.closeOrderRepeat = function () {
                $.closeModal('.order_repeat');
            }
            //去订单列表
            $scope.showOrderList = function () {
                if (browser.versions.android) {
                    JSBridge.goToList();
                } else {
                    window.webkit.messageHandlers.goToList.postMessage(null);
                }
            }
            //显示房间数弹框
            $scope.openRoomNumBox = function () {
                $.popup('.rooms_number');
            }
            //关闭选择房间数弹框
            $scope.closeRoomNumBox = function () {
                $.closeModal('.rooms_number');
            }
            //选择房间数
            var roomTemplateStr = '';
            var roomNumHtml = '';
            var roomTotalPrice = jsonRoomInfo.roomPrice * jsonRoomInfo.dayCount;
            $(".room_number_lb>li").click(function () {
                $(this).addClass("choose").siblings("li").removeClass("choose");
                $(".open-room_number").html($(this).html());
                //入住人
                var roomNum = parseInt($(".open-room_number").html());
                if (!roomTemplateStr){
                    roomTemplateStr = '<div class="item-content"><input type="text" class="guesterName" placeholder="(每间房填写一人即可)" maxlength="10" /></div> ';
                }
                for (var i = 0; i < roomNum; i++) {
                    roomNumHtml += roomTemplateStr;
                }
                $("#div_roomNum").empty();
                $("#div_roomNum").append(roomNumHtml);

                //计算价格
                roomTotalPrice = roomNum * jsonRoomInfo.roomPrice * jsonRoomInfo.dayCount;
                $("#order_amount").html("￥" + Math.round(roomTotalPrice));
                //清空变量，关闭弹层
                roomNumHtml = "";
                $.closeModal('.rooms_number');
                //判断是否为房量担保
                isAmountGuarantee(roomNum);
            });

            //显示保留时间弹框
            $scope.showCheckInTimeBox = function () {
                $.popup('.time_number');
            }
            //关闭保留时间弹框
            $scope.closeCheckInTimeBox = function () {
                $.closeModal('.time_number');
            }
            //选择保留时间
            $scope.chooseLatestArriveTime = function (event) {
                $(".time_number").find("li").removeClass("choose");
                $(event.target).addClass("choose");
                $.closeModal('.time_number');
                var latestArriveTime = $(event.target).attr("attr-value").substring(0,10).trim(),
                    latestArriveHour = $(event.target).text().trim();
                if(latestArriveHour.indexOf("凌晨") > -1){
                    isMorningArrivalTime = true;
                }else {
                    isMorningArrivalTime = false;
                }
                if (latestArriveTime.indexOf('/') > 0) {
                    latestArriveTime = latestArriveTime.replace('/', '-').replace('/', '-');
                }
                latestArriveTime = latestArriveTime + " " + latestArriveHour;

                //选中最晚到店时间
                $(".open-time_number").html(latestArriveTime);
                $("#hid_lastArriveTime").val(latestArriveTime);
                //判断是否为到店担保
                IsTimeGuarantee(latestArriveTime);
            }

            //价格明细
            $scope.showPriceDetail = function () {
                $.popup('.Price-list');
            }
            $scope.closePriceDetail = function () {
                $.closeModal('.Price-list');
            }
            //日期计算星期几
            var weekArray = new Array("星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六");
            $scope.parseDateToWeekDay = function (date) {
                if (date.indexOf('T') > 0)
                    date = date.split('T')[0];
                return weekArray[new Date(date).getDay()];
            }
            //根据星期几计算价格
            $scope.getDailyPrice = function (price) {
                var weekPrice = getDailyPrice(price);
                if(weekPrice <= 0){
                    return "满房";
                }else{
                    return "￥" + Math.round(getDailyPrice(price)) + "/间";
                }
            }

            function getDailyPrice(price) {
                var date = price.StartDate;
                if (date.indexOf('T') > 0){
                    date = date.split('T')[0];
                }

                if (0 == new Date(date).getDay() || 6 == new Date(date).getDay()){
                    return price.Weekend;
                } else{
                    return price.Member;
                }
            }
            //格式化日期
            $scope.formatDate = function (date) {
                if (date.indexOf('T') > 0)
                    return date.split('T')[0];
                else
                    return date.split(' ')[0];
            }
            if (NeedGuarantee) {
                $("#div_creditcard").show();
            }
            //跳转到填写发票信息界面
            $scope.toFillIinvoice = function () {
                var guesterList = [];
                $(".guesterName").each(function () {
                    guesterList.push({
                        "name": $.trim($(this).val())
                    });
                });
                var _orderInfo = {
                    NumberOfRooms: parseInt($(".open-room_number").html()),
                    guesterList: guesterList,
                    ContactName: $("#contactName").val(),
                    ContactMobile: $("#contactMobile").val(),
                    LatestArrivalTimeString: $("#hid_lastArriveTime").val(),
                }
                localStorage.setItem("ORDERINFO",JSON.stringify(_orderInfo));
                commonService.gotoPage('fillInvoice');
            }
            var orderInfo = JSON.parse(localStorage.getItem("ORDERINFO"));
            if(orderInfo){
                orderService.getOptionLatestArrivalTime({arriveDate: jsonRoomInfo.arriveDate}).then(function (res) {
                    if (res.ReturnCode == 200) {
                        $scope.optionLatestArriveTime = res.Data;
                        IsTimeGuarantee($scope.minLatestArriveTime);
                    }
                });
                var params = {
                    arriveDate: jsonRoomInfo.arriveDate,
                    departureDate: jsonRoomInfo.departureDate,
                    hotelId: jsonRoomInfo.hotelId,
                    roomId: jsonRoomInfo.roomId,
                    roomTypeId: jsonRoomInfo.roomTypeId,
                    ratePlanId: jsonRoomInfo.ratePlanId,
                    paymentType: jsonRoomInfo.paymentType,//支付方式  2是网上现付
                    hotelCode: jsonRoomInfo.hotelCode
                }
                orderService.getOrderPriceDetail(params).then(function (res) {
                    if (res && res.ReturnCode == 200 && res.Data && res.Data.Rates) {
                        $scope.priceList = res.Data.Rates;
                    }
                });
                $(".open-room_number").html(orderInfo.NumberOfRooms + "间");
                var _html = '';
                for(var i = 0; i < orderInfo.NumberOfRooms; i++){
                    _html += '<div class="item-content"><input type="text" class="guesterName" value="' + orderInfo.guesterList[i].name + '" maxlength="10" /></div>';
                }
                angular.element(document).ready(function () {
                    $("#div_roomNum").html(_html);
                });
                $("#contactName").val(orderInfo.ContactName);
                $("#contactMobile").val(orderInfo.ContactMobile);
                roomTotalPrice = Math.round(orderInfo.NumberOfRooms * jsonRoomInfo.roomPrice * jsonRoomInfo.dayCount);
                $scope.order_amount = "￥" + roomTotalPrice;
                $scope.minLatestArriveTime = orderInfo.LatestArrivalTimeString;
                $("#hid_lastArriveTime").val(orderInfo.LatestArrivalTimeString);
                if(orderInfo.LatestArrivalTimeString.indexOf("凌晨") > -1){
                    isMorningArrivalTime = true;
                }else {
                    isMorningArrivalTime = false;
                }
            }else {
                //获取订单价格明细
                var params = {
                    arriveDate: jsonRoomInfo.arriveDate,
                    departureDate: jsonRoomInfo.departureDate,
                    hotelId: jsonRoomInfo.hotelId,
                    roomId: jsonRoomInfo.roomId,
                    roomTypeId: jsonRoomInfo.roomTypeId,
                    ratePlanId: jsonRoomInfo.ratePlanId,
                    paymentType: jsonRoomInfo.paymentType,//支付方式  2是网上现付
                    hotelCode: jsonRoomInfo.hotelCode
                }
                orderService.getOrderPriceDetail(params).then(function (res) {
                    if (res && res.ReturnCode == 200 && res.Data && res.Data.Rates) {
                        var rateList = res.Data.Rates;
                        $scope.priceList = rateList;

                        //计算总价
                        var totalPrice = 0;
                        for (var i = 0, length = rateList.length; i < length; i++) {
                            totalPrice += getDailyPrice(rateList[i]);
                        }
                        roomTotalPrice = totalPrice;
                        if(totalPrice <= 0){
                            $scope.order_amount = "满房";
                        }else{
                            $scope.order_amount = "￥" + Math.round(totalPrice);
                        }
                    }
                });
                //最晚到店时间赋值
                orderService.getOptionLatestArrivalTime({arriveDate: jsonRoomInfo.arriveDate}).then(function (res) {
                    if (res.ReturnCode == 200) {
                        $scope.optionLatestArriveTime = res.Data;
                        $scope.minLatestArriveTime = res.Data[0].Value.substring(0,10) + " " + res.Data[0].ShowTime;
                        IsTimeGuarantee($scope.minLatestArriveTime);
                    }
                });
            }
            //#region 提交订单
            //校验参数
            function validateParams() {
                //登录会员id
                if (!localStorage.getItem(appconfig.USER_ID)) {
                    $.toast("未获取到登录信息，请重新登录");
                    return false;
                }
                //联系人信息校验
                if (!$("#contactName").val() || !$.trim($("#contactName").val())) {
                    $.toast("联系人姓名不能为空");
                    return false;
                } else if (!commonService.verifyName($.trim($("#contactName").val()))) {
                    $.toast("请输入真实姓名");
                    return false;
                }
                if ($.trim($("#contactMobile").val()) == "") {
                    $.toast("联系人手机号不能为空");
                    return false;
                } else if (!commonService.verifyMobile($.trim($("#contactMobile").val()))) {
                    $.toast("请输入真实手机号");
                    return false;
                }
                if (NeedGuarantee) {
                    //信用卡信息校验
                    if ($.trim($('#cardNumber').val()) == '') {
                        $.toast("信用卡号码不能为空");
                        return false;
                    }
                    if($.trim($('#expiration').val()) == ''){
                        $.toast("信用卡有效期不能为空");
                        return false;
                    }else if($('#expiration').val().indexOf('/') < 0){
                        $.toast("信用卡有效期格式不对");
                        return false;
                    }
                }
                return true;
            }
            //订单
            $scope.submitOrder = function () {
                //参数验证
                if (!validateParams()) {
                    return false;
                }
                //准备提交数据
                var guesterList = [];
                //宾客信息校验
                $(".guesterName").each(function () {
                    guesterList.push({
                        "name": $.trim($(this).val())
                    });
                });
                IsNeedInvoice = localStorage.getItem('IsNeedInvoice') ? JSON.parse(localStorage.getItem('IsNeedInvoice')) : false;//是否需要发票
                if(IsNeedInvoice){
                    Invoice.Amount = Math.round(roomTotalPrice);
                }
                var reqDate = {
                    HotelId: jsonRoomInfo.hotelId,
                    RatePlanId: jsonRoomInfo.ratePlanId,
                    RoomTypeId: jsonRoomInfo.roomTypeId,
                    ArrivalDate: jsonRoomInfo.arriveDate,
                    DepartureDate: jsonRoomInfo.departureDate,
                    NumberOfRooms: parseInt($(".open-room_number").html()),
                    LatestArrivalTimeString: $("#hid_lastArriveTime").val(),
                    CustomerIPAddress: "127.0.0.1",
                    Contact: {
                        Name: $("#contactName").val(),
                        Mobile: $("#contactMobile").val()
                    },
                    GuesterList: guesterList,
                    TotalPrice: Math.round(roomTotalPrice),
                    HotelName: jsonRoomInfo.hotelName,
                    RoomName: jsonRoomInfo.roomName,
                    RoomDescription: jsonRoomInfo.roomDescription,
                    UserId: localStorage.getItem(appconfig.USER_ID) || "12345678",
                    PaymentType: jsonRoomInfo.paymentType,
                    CreditCard: {
                        Number: $("#cardNumber").val(),
                        ExpirationYear: $("#expiration").val().split('/')[1],
                        ExpirationMonth: $("#expiration").val().split('/')[0],
                        IdType: "IdentityCard",
                        IdNo: "640302199412319552",
                        Cvv: $("#cvv").val(),
                        HolderName: $("#contactName").val()
                    },
                    NeedGuarantee: NeedGuarantee,
                    isMorningArrivalTime : isMorningArrivalTime,
                    IsNeedInvoice: IsNeedInvoice,//是否需要发票
                    InvoiceMode: $scope.InvoiceMode,
                    Invoice: Invoice,//发票信息
                };
                if(jsonRoomInfo.paymentType == 1){
                    orderService.submitOrder(reqDate).then(function (res) {
                        if (res.ReturnCode == 200) {
                            localStorage.removeItem('INVOICE_TITLE');
                            localStorage.removeItem('INVOICE_ADDRESS');
                            localStorage.removeItem('IsNeedInvoice');
                            localStorage.removeItem('INVOICE');
                            localStorage.removeItem('ORDERINFO');
                            if (res.Data.OrderCode)
                                commonService.gotoPage("orderDetail", {
                                    orderId: res.Data.OrderCode
                                });
                        } else {
                            var status = res.Message.indexOf('|') > 0 ? res.Message.split('|')[0] : res.Message;
                            var msg = res.Message.indexOf('|') > 0 ? res.Message.split('|')[1] : res.Message;
                            if(msg == "需要提供信用卡" || status == "H001083"){
                                $.toast("此房不可预订或满房");
                            }else if(status == "H001045"){
                                $.popup('.order_repeat');//疑似重复订单，不进行处理
                            }else{
                                $.toast(msg);
                            }
                        }
                    });
                }else{
                    orderService.submitGaranteeOrder(reqDate).then(function (res) {
                        if (res.ReturnCode == 200) {
                            localStorage.removeItem('INVOICE_TITLE');
                            localStorage.removeItem('INVOICE_ADDRESS');
                            localStorage.removeItem('IsNeedInvoice');
                            localStorage.removeItem('INVOICE');
                            localStorage.removeItem('ORDERINFO');
                            var _appData = {
                                HotelName : jsonRoomInfo.hotelName,//酒店名称
                                room_name : jsonRoomInfo.roomName,//房屋名称
                                room_arriveDate : jsonRoomInfo.arriveDate,//入住日期
                                room_departureDate : jsonRoomInfo.departureDate,//离店日期
                                room_dayCount : jsonRoomInfo.dayCount,//时间
                                orderCode : res.Data.CreateOrderRes.OrderCode,//订单号
                                totalPrice : Math.round(roomTotalPrice), //总价
                            }
                            if (browser.versions.ios || browser.versions.iPhone || browser.versions.iPad) {
                                window.webkit.messageHandlers.goToPay.postMessage(JSON.stringify(_appData));
                            }else{
                                JSBridge.goToPay(JSON.stringify(_appData));
                            }
                        } else {
                            var status = res.Message.indexOf('|') > 0 ? res.Message.split('|')[0] : res.Message;
                            var msg = res.Message.indexOf('|') > 0 ? res.Message.split('|')[1] : res.Message;
                            if(status == "H001083"){
                                $.toast("此房不可预订或满房");
                            }else if(status == "H001045"){
                                $.popup('.order_repeat');//疑似重复订单，不进行处理
                            }else{
                                $.toast(msg);
                            }
                        }
                    });
                }
            }
            //#endregion
            function IsTimeGuarantee(latestArriveTime) {
                latestArriveTime = latestArriveTime.trim();
                if (guaranteeRule != null && inGuaranteeTime && guaranteeRule.IsTimeGuarantee) {
                    var nowTime = latestArriveTime.substr(latestArriveTime.length - 5);
                    if ((nowTime >= guaranteeRule.StartTime && nowTime <= guaranteeRule.EndTime) || (nowTime >= guaranteeRule.StartTime && guaranteeRule.StartTime >= guaranteeRule.EndTime) || (guaranteeRule.EndTime >= nowTime && guaranteeRule.StartTime >= nowTime)) {
                        $scope.card_guarantee = guaranteeRule.Description;
                        $('.card_guarantee').show();
                        $("#div_creditcard").show();
                        NeedGuarantee = true;
                    } else {
                        $('.card_guarantee').hide();
                        $("#div_creditcard").hide();
                        NeedGuarantee = false;
                    }
                }
            }

            function isAmountGuarantee(roomNum) {
                if (guaranteeRule != null && inGuaranteeTime && guaranteeRule.IsAmountGuarantee) {
                    if (roomNum >= guaranteeRule.Amount) {
                        $scope.card_guarantee = guaranteeRule.Description;
                        $('.card_guarantee').show();
                        $("#div_creditcard").show();
                        NeedGuarantee = true;
                    } else {
                        $('.card_guarantee').hide();
                        $("#div_creditcard").hide();
                        NeedGuarantee = false;
                    }
                }
            }

            $scope.addAddress = function(){
                commonService.gotoPage('addAddress');
            }
            //返回酒店详情
            $scope.backToDetail = function () {
                localStorage.removeItem('INVOICE_TITLE');
                localStorage.removeItem('INVOICE_ADDRESS');
                localStorage.removeItem('IsNeedInvoice');
                localStorage.removeItem('INVOICE');
                localStorage.removeItem('ORDERINFO');
                commonService.gotoPage("hotelDetail", {
                    hotelId: jsonRoomInfo.hotelId
                });
            }
            //手机物理返回键处理页面跳转和模态框取消
            $window.appCloseModal = function () {
                if ($('body').has('.modal-in').length > 0) {
                    $.closeModal('.modal-in');
                }else{
                    $scope.backToDetail();
                }
            }
            if (browser.versions.ios || browser.versions.iPhone || browser.versions.iPad) {
                $('.header_hide').hide();
                $('.content_wrap').css('top', 0);
                $('input').on('focus',function (event) {
                    var target = this;
                    setTimeout(function () {
                        target.scrollIntoViewIfNeeded();
                    },100)
                });
            }
        }
    ])
    .controller("fillInvoiceCtrl", ["$scope", "$stateParams", "orderService", "commonService", "$window",
        function ($scope,$stateParams,orderService,commonService,$window) {
            //是否需要发票
            var ItemName = "代订住宿费";
            var local_invoiceTitle = JSON.parse(localStorage.getItem('INVOICE_TITLE'));//发票抬头信息
            var local_address = JSON.parse(localStorage.getItem('INVOICE_ADDRESS'));
            if(local_invoiceTitle){
                var invoiceTitle = local_invoiceTitle;
                $('#headName').html(local_invoiceTitle.Title + "<br>" + local_invoiceTitle.ITIN);
            }
            if(local_address){
                var address = local_address;
                $('#distributionAddress').html(local_address.Name + " " + local_address.Phone + "<br>" + local_address.Province + local_address.City + local_address.District + local_address.Street);

            }
            $scope.isNeedInvoiceClick = function(){
                if($('.icon-off').hasClass('rotate')){
                    $('.IsNeedInvoice,.finishToOrder').hide();
                    $('#distributionAddress').text('请填写详细的配送地址');
                    localStorage.setItem('IsNeedInvoice',false);
                    localStorage.removeItem('INVOICE_TITLE');
                    localStorage.removeItem('INVOICE_ADDRESS');
                    localStorage.removeItem('INVOICE');
                }else{
                    $('.IsNeedInvoice,.finishToOrder').show();
                }
                $('.icon-off').toggleClass('rotate');
            }
            //发票内容
            $('.ItemName>.item-input').click(function () {
                var $this = $(this);
                $this.children('span').addClass('active');
                $this.siblings('.item-input').children('span').removeClass('active');
                ItemName = $this.children('span').text();
            });
            //完成调整到订单页面
            $scope.finishToOrder = function () {
                if(local_address && local_invoiceTitle){
                    var Invoice = {
                        InvoiceType  : 1,//发票类型
                        TitleType    : invoiceTitle.TitleType,//抬头类型
                        Title        : invoiceTitle.Title,//抬头
                        ITIN         : invoiceTitle.ITIN,//纳税人识别号/统一社会信用代码
                        ItemName     : ItemName,//发票内容
                        Recipient    : address,//收件人
                        IsNeedRelationOrder: false,//是否添加发票备注
                    }
                }else{
                    var Invoice = {
                        InvoiceType  : 1,//发票类型
                        TitleType    : '',//抬头类型
                        Title        : '',//抬头
                        ITIN         : '',//纳税人识别号/统一社会信用代码
                        ItemName     : '',//发票内容
                        Recipient    : {},//收件人
                        IsNeedRelationOrder: false,//是否添加发票备注
                    }
                }
                if($('#headName').text() == '请填写发票抬头信息' || $('#headName').text() == ''){
                    $.toast('请填写发票抬头名称');return false;
                }
                if($('#distributionAddress').text() == "请填写详细的配送地址" || $('#distributionAddress').text() == ''){
                    $.toast('请填写发票邮寄地址');return false;
                }
                localStorage.setItem('IsNeedInvoice',true);
                localStorage.setItem('INVOICE',JSON.stringify(Invoice));
                commonService.gotoPage('hotelOrder');
            }
            //返回上一页
            $scope.backToOrder = function () {
                commonService.gotoPage('hotelOrder');
            }
            $scope.openInvoiceTitle = function () {
                commonService.gotoPage('invoiceList');
            }
            //添加收获地址
            $scope.toAddAddress = function(){
                commonService.gotoPage('addressList');
            }
            $window.appCloseModal = function () {
                $scope.backToOrder();
            }
            if (browser.versions.ios || browser.versions.iPhone || browser.versions.iPad) {
                $('.header_hide').hide();
                $('.content_wrap').css('top', 0);
            }
        }
    ])
    .controller("invoiceListCtrl", ["$scope", "$stateParams", "orderService", "commonService", "$window",
        function ($scope,$stateParams,orderService,commonService,$window) {
            var user_id = localStorage.getItem('USER_ID'),//用户id
                TitleType = 2;//抬头类型
            function getInvoiceList(){
                var _params = {
                    PageIndex: 0,
                    PageSize: 1000,
                    UserId: user_id,
                };
                orderService.getInvoiceList(_params).then(function (res) {
                    if(res.ReturnCode == 200){
                        $scope.InvoiceList = res.list;
                    }

                })
            }
            getInvoiceList();
            //添加发票抬头信息
            $scope.addInvoiceTitle = function(){
                $('#AddInvoiceTitle').show();
                $('#EditInvoiceTitle').hide();
                $('.invoice-title').val('');
                $('.registNum').val('');
                $.popup('.add_invoice_title');
            }
            $scope.closeAddInvoiceTitleModel = function(){
                $.closeModal('.add_invoice_title');
            }
            //删除发票抬头信息
            $scope.deleteInvoice = function(id){
                $.confirm('确定删除该条发票抬头信息吗?',function () {
                    var _params = {
                        Id: id,
                        UserId: user_id
                    }
                    orderService.delInvoice(_params).then(function (res) {
                        if(res.ReturnCode == 200){
                            getInvoiceList();
                        }else{
                            $.toast(res.Message);
                        }
                    })
                })
            }
            //修改发票信息
            $scope.editInvoicePage = function(params){
                if(params.TitleType == '1'){
                    $('.nashuiren').hide();
                    $('.registNum').val('');
                }else{
                    $('.nashuiren').show();
                }
                $('.invoice_type_' + params.TitleType).children('span').removeClass('icon-weixuan').addClass('icon-choose');
                $('.invoice_type_' + params.TitleType).siblings('.item-input').children('span').removeClass('icon-choose').addClass('icon-weixuan');
                $('.invoice-title').val(params.Title);
                $('.registNum').val(params.ITIN);
                TitleType = params.TitleType;
                $('#AddInvoiceTitle').hide();
                $('#EditInvoiceTitle').show();
                $('#editInvoiceId').val(params.Id);
                $.popup('.add_invoice_title');
            }
            $scope.submitInvoiceTitleEditMsg = function(){
                var _params = {
                    TitleType: TitleType,//抬头类型
                    Title: $('.invoice-title').val(),//抬头信息
                    ITIN: $('.registNum').val(),//纳税人识别号/统一社会信用代码
                    UserId: user_id,//用户id
                    Id: $('#editInvoiceId').val()
                }
                if(!_params.Title){
                    $.toast('请输入发票抬头信息');return false;
                }
                if(_params.TitleType == '2' && !_params.ITIN){
                    $.toast('请填写纳税人识别号');return false;
                }
                orderService.editInvoice(_params).then(function (res) {
                    if(res.ReturnCode == 200){
                        $.closeModal('.add_invoice_title');
                        getInvoiceList();
                    }else {
                        $.toast(res.Message);
                    }
                })
            }
            $scope.checkInvoiceTitle = function(params){
                var _params = {
                    Id: params.Id,
                    UserId: user_id,
                }
                orderService.editLsSort(_params).then(function (res) {
                    if(res.ReturnCode == 200){
                        getInvoiceList();
                        localStorage.setItem('INVOICE_TITLE',JSON.stringify(params));
                        commonService.gotoPage('fillInvoice');
                    }else{
                        $.toast(res.Message);
                    }
                })
            }
            //抬头类型
            $('#invoice_type>.item-input').click(function () {
                var $this = $(this);
                $this.children('span').removeClass('icon-weixuan').addClass('icon-choose');
                $this.siblings('.item-input').children('span').removeClass('icon-choose').addClass('icon-weixuan');
                var _type = $this.attr('TitleType');
                if(_type == '1'){
                    $('.nashuiren').hide();
                    $('.registNum').val('');
                }else if(_type == '2'){
                    $('.nashuiren').show();
                    $('.registNum').attr('placeholder','税务登记证上的编号,必填');
                }else{
                    $('.nashuiren').show();
                    $('.registNum').attr('placeholder','税务登记证上的编号,选填');
                }
                TitleType = _type;
            });
            $scope.submitInvoiceTitleMsg = function(){
                var _params = {
                    TitleType: TitleType,//抬头类型
                    Title: $('.invoice-title').val(),//抬头信息
                    ITIN: $('.registNum').val(),//纳税人识别号/统一社会信用代码
                    UserId: user_id,//用户id
                }
                if(!_params.Title){
                    $.toast('请输入发票抬头名称');return false;
                }
                if(_params.TitleType == 2 && !_params.ITIN){
                    $.toast('企业单位必须输入纳税人识别号');return false;
                }
                orderService.addInvoice(_params).then(function (res) {
                    if(res.ReturnCode == 200){
                        $.closeModal('.add_invoice_title');
                        getInvoiceList();
                    }else{
                        $.toast(res.message);
                    }
                })
            }
            $scope.closeInvoiceTitleModel = function(){
                commonService.gotoPage('fillInvoice');
            }
            //手机物理返回键处理页面跳转和模态框取消
            $window.appCloseModal = function () {
                if ($('body').has('.modal-in').length > 0) {
                    $.closeModal('.modal-in');
                } else {
                    $scope.closeInvoiceTitleModel();
                }
            }
            if (browser.versions.ios || browser.versions.iPhone || browser.versions.iPad) {
                $('.header_hide').hide();
                $('.content_wrap').css('top', 0);
            }
        }
    ])
    .controller("addressListCtrl", ["$scope", "$stateParams", "orderService", "commonService", "$window",
        function ($scope,$stateParams,orderService,commonService,$window) {
            var user_id = localStorage.getItem('USER_ID');
            $scope.addAddress = function(){
                $('#addAddress').show();
                $('#editAddress').hide();
                $('input').val('');
                $("#city-picker").cityPicker({
                    toolbarTemplate: '<header class="bar bar-nav header header_hide"><a class="button button-link button-nav pull-left vr_middle close-picker"><span class="icon back_icon"></span></a><h1 class="title">添加邮寄地址</h1><button class="button button-link pull-right close-picker">确定</button></header>',
                    rotateEffect: true,
                    cssClass: "city-select"
                });
                $.popup('.invoice_address');
            }
            $scope.closeAddressListModel = function () {
                commonService.gotoPage('fillInvoice');
            }
            //获取收获地址列表
            function getAddressList(){
                var _params = {
                    PageIndex: 0,
                    PageSize: 1000,
                    UserId: user_id,
                };
                orderService.getRecipientList(_params).then(function (res) {
                    if(res.ReturnCode == 200){
                        $scope.addressList = res.list;
                    }
                })
            }
            getAddressList();
            //点击确定按钮提交 添加地址
            $scope.submitAddress = function(){
                var city = $('#city-picker').val();
                var city_arr = city.split(" ");
                for(var i = 0; i < city_arr.length; i++){
                    if(city_arr[i] == "" || typeof(city_arr[i]) == undefined){
                        city_arr.splice(i,1);
                        i--;
                    }
                }
                if(city_arr.length == 3){
                    var Recipient = {
                        Province  : city_arr ? city_arr[0] : '',//省
                        City      : city_arr ? city_arr[1] : '',//城市
                        District  : city_arr ? city_arr[2] : '',//县，行政区
                        Street    : $('.Recipient_Street').val(),//街道
                        PostalCode: $('.Recipient_PostalCode').val(),//邮编
                        Name      : $('.Recipient_Name').val(),//收件人
                        Phone     : $('.Recipient_Phone').val(),//电话
                        Email     : '',//电子邮箱
                        UserId    : user_id
                    }
                }else{
                    var Recipient = {
                        Province  : city_arr ? city_arr[0] : '',//省
                        City      : city_arr ? city_arr[0] : '',//城市
                        District  : city_arr ? city_arr[1] : '',//县，行政区
                        Street    : $('.Recipient_Street').val(),//街道
                        PostalCode: $('.Recipient_PostalCode').val(),//邮编
                        Name      : $('.Recipient_Name').val(),//收件人
                        Phone     : $('.Recipient_Phone').val(),//电话
                        Email     : '',//电子邮箱
                        UserId    : user_id
                    }
                }
                if(!Recipient.Name){
                    $.toast('请输入收件人姓名');return false;
                }
                if(!Recipient.Phone){
                    $.toast("请输入手机号码");return false;
                }else if(!commonService.verifyMobile(Recipient.Phone)){
                    $.toast("请输入真实手机号");return false;
                }
                if(!Recipient.Province || !Recipient.City || !Recipient.District || !Recipient.Street){
                    $.toast('请输入您的详细邮寄地址');return false;
                }
                orderService.addRecipient(Recipient).then(function (res) {
                    if(res.ReturnCode == 200){
                        getAddressList();
                        $.closeModal('.invoice_address');
                    }else{
                        $.toast(res.Message);
                    }
                })
                $.closeModal('.invoice_address');
            }
            //点击修改按钮提交 修改地址
            $scope.submitAddressForEdit = function(){
                var city = $('#city-picker').val();
                var city_arr = city.split(" ");
                for(var i = 0; i < city_arr.length; i++){
                    if(city_arr[i] == "" || typeof(city_arr[i]) == undefined){
                        city_arr.splice(i,1);
                        i--;
                    }
                }
                if(city_arr.length == 3){
                    var Recipient = {
                        Province  : city_arr ? city_arr[0] : '',//省
                        City      : city_arr ? city_arr[1] : '',//城市
                        District  : city_arr ? city_arr[2] : '',//县，行政区
                        Street    : $('.Recipient_Street').val(),//街道
                        PostalCode: $('.Recipient_PostalCode').val(),//邮编
                        Name      : $('.Recipient_Name').val(),//收件人
                        Phone     : $('.Recipient_Phone').val(),//电话
                        Email     : '',//电子邮箱
                        Id        : $('.address_id').val(),
                        UserId    : user_id
                    }
                }else{
                    var Recipient = {
                        Province  : city_arr ? city_arr[0] : '',//省
                        City      : city_arr ? city_arr[0] : '',//城市
                        District  : city_arr ? city_arr[1] : '',//县，行政区
                        Street    : $('.Recipient_Street').val(),//街道
                        PostalCode: $('.Recipient_PostalCode').val(),//邮编
                        Name      : $('.Recipient_Name').val(),//收件人
                        Phone     : $('.Recipient_Phone').val(),//电话
                        Email     : '',//电子邮箱
                        Id        : $('.address_id').val(),
                        UserId    : user_id
                    }
                }
                if(!Recipient.Name){
                    $.toast('请输入收件人姓名');return false;
                }
                if(!Recipient.Phone){
                    $.toast("请输入手机号码");return false;
                }else if(!commonService.verifyMobile(Recipient.Phone)){
                    $.toast("请输入真实手机号");return false;
                }
                if(!Recipient.Province || !Recipient.City || !Recipient.District || !Recipient.Street){
                    $.toast('请输入您的详细邮寄地址');return false;
                }
                orderService.editRecipient(Recipient).then(function (res) {
                    if(res.ReturnCode == 200){
                        getAddressList();
                        $.closeModal('.invoice_address');
                    }else{
                        $.toast(res.Message);
                    }
                })
                $.closeModal('.invoice_address');
            }
            $scope.checkAddress = function(address){
                var _params = {
                    Id: address.Id,
                    UserId: user_id
                }
                orderService.editRecipientIsSort(_params).then(function (res) {
                    if(res.ReturnCode == 200){
                        getAddressList();
                        localStorage.setItem('INVOICE_ADDRESS',JSON.stringify(address));
                        commonService.gotoPage('fillInvoice',address);
                    }else{
                        $.toast(res.Message);
                    }
                })

            }
            $scope.deleteAddress = function(id){
                $.confirm('确定删除该条地址吗?',function () {
                    var _params = {
                        Id: id,
                        UserId: user_id
                    }
                    orderService.delRecipientById(_params).then(function (res) {
                        if(res.ReturnCode == 200){
                            getAddressList();
                        }else{
                            $.toast(res.Message);
                        }
                    })
                })
            }
            $scope.closeAddress = function () {
                $.closeModal('.invoice_address');
            }
            $scope.editAddressPage = function(address){
                $('#addAddress').hide();
                $('#editAddress').show();
                $('.Recipient_Name').val(address.Name);
                $('.Recipient_Phone').val(address.Phone);
                $('.Recipient_Street').val(address.Street);
                $('.Recipient_PostalCode').val(address.PostalCode);
                $('.address_id').val(address.Id);
                $("#city-picker").cityPicker({
                    toolbarTemplate: '<header class="bar bar-nav header header_hide"><a class="button button-link button-nav pull-left vr_middle close-picker"><span class="icon back_icon"></span></a><h1 class="title">添加邮寄地址</h1><button class="button button-link pull-right close-picker">确定</button></header>',
                    rotateEffect: true,
                    cssClass: "city-select",
                    value: [address.Province, address.City, address.District]
                });
                $.popup('.invoice_address');
            }
            //手机物理返回键处理页面跳转和模态框取消
            $window.appCloseModal = function () {
                if ($('body').has('.modal-in').length > 0) {
                    $.closeModal('.modal-in');
                    $.closeModal(".picker-modal.modal-in");
                    $('.popup-overlay').remove();
                }else{
                    $scope.closeAddressListModel();
                }
            }
            if (browser.versions.ios || browser.versions.iPhone || browser.versions.iPad) {
                $('.header_hide').hide();
                $('.content_wrap').css('top', 0);
            }
        }
    ])
    .controller("orderListCtrl", ["$scope", "$stateParams", "orderService", "commonService", "$window",
        function ($scope, $stateParams, orderService, commonService, $window) {
            //*************************验证登录，获取用户信息 begin ****************
            commonService.autoLoginFromParams($stateParams);
            //*************************验证登录，获取用户信息 end   ****************
            //#regioon 订单列表
            if (!localStorage.getItem(appconfig.USER_ID))
                return;
            //获取订单列表
            var pageIndex = 1;
            var pageSize = 15;
            var type;
            $scope.orderList = [];

            function getOrderList(type) {
                var params = {
                    userId: localStorage.getItem(appconfig.USER_ID),
                    type: type,
                    pageIndex: pageIndex,
                    pageSize: pageSize,
                };
                orderService.getOrderListByUserId(params).then(function (res) {
                    if (res.ReturnCode == 200) {
                        var count = res.list.length;
                        for (var i = 0; i < count; i++) {
                            if (res.list[i].ArriveDate.indexOf('Date') > 0) {
                                res.list[i].ArriveDate = commonService.jsonDateFormat(res.list[i].ArriveDate, "yyyy-MM-dd");
                            } else if (res.list[i].ArriveDate.indexOf('T') > 0) {
                                res.list[i].ArriveDate = res.list[i].ArriveDate.substring(0, res.list[i].ArriveDate.indexOf('T'));
                            } else if (res.list[i].ArriveDate.indexOf(' ') > 0) {
                                res.list[i].ArriveDate = res.list[i].ArriveDate.substring(0, res.list[i].ArriveDate.indexOf(' '));
                            }
                            $scope.orderList.push(res.list[i]);
                        }
                        if($scope.orderList.length == 0){
                            $('.no_order').show();
                        }else{
                            $('.no_order').hide();
                        }
                        if (count <= 15) {
                            pageIndex++;
                            $('.infinite-scroll-preloader').hide();
                        } else {
                            $('.infinite-scroll-preloader').show();
                            pageIndex++;
                        }
                    } else {
                        $.detachInfiniteScroll($('.infinite-scroll'));
                        $('.infinite-scroll-preloader').remove();
                        $.toast("没有更多了");
                        return;
                    }
                });
            }
            //订单状态 数字转化字符串
            $scope.convertOrderStatus = function (status) {
                return commonService.convertOrderStatus(status);
            }

            //判断订单状态样式
            $scope.setOrderStatusStyle = function (status) {
                if (status != '256')
                    return "leave";
                else
                    return "cancel";
            }

            //滑动加载更多数据
            $(document).on("pageInit", "#page-infinite-scroll-bottom", function (e, id, page) {
                var loading = false;
                getOrderList(type);

                $(page).on('infinite', function () {
                    // 如果正在加载，则退出
                    if (loading) return;
                    // 设置flag
                    loading = true;
                    // 模拟1s的加载过程
                    setTimeout(function () {
                        // 重置加载flag
                        loading = false;
                        getOrderList(type);
                        $.refreshScroller();
                    }, 1000);
                });
            });
            $.init();
            //点击头部不同状态
            $(".order_list_head>li").click(function () {
                $scope.orderList = [];
                $(this).addClass('active').siblings().removeClass('active');
                pageIndex = 1;
                type = $(this).attr("type");
                getOrderList(type);

            });
            //跳转到订单详情
            $scope.toOrderDetail = function (OrderCode) {
                commonService.gotoPage("orderDetail", {
                    orderId: OrderCode
                });
            }
            //继续担保
            $scope.toGuarantee = function (OrderCode) {
                commonService.gotoPage("guarantee", {
                    orderId: OrderCode
                });
            }
            //继续去支付
            $scope.toAppPay = function(order){
                if(order.ShowStatus == 8){
                    var _appData = {
                        HotelName : order.HotelName,//酒店名称
                        room_name : order.RoomName,//房屋名称
                        room_arriveDate : order.ArriveDate,//入住日期
                        room_departureDate : order.DepartureDate,//离店日期
                        room_dayCount : order.NumOfDays,//时间
                        orderCode : order.OrderCode,//订单号
                        totalPrice : order.TotalPrice, //总价
                    }
                    if (browser.versions.android) {
                        JSBridge.goToPay(JSON.stringify(_appData));
                    } else {
                        window.webkit.messageHandlers.goToPay.postMessage(JSON.stringify(_appData));
                    }
                }
            }

            //返回上一页
            $scope.goLastPage = function () {
                if (localStorage.getItem(appconfig.RETURN_BACK_PAGE_KEY)) {
                    window.location.href = "http://www.trip.org";
                    localStorage.clear();
                }
            }
            //手机物理返回键处理页面跳转和模态框取消
            $window.appCloseModal = function () {
                if ($('body').has('.modal-in').length > 0) {
                    $.closeModal('.modal-in');
                } else {
                    $scope.goLastPage();
                }
            }
            $scope.getFormatDate = function (date) {
                return commonService.getDateFormat(date, "MM-dd");
            }
            $scope.getWeakName = function (date) {
                return commonService.getWeakName(date);
            }
            $scope.goToOrder = function () {
                if (browser.versions.android) {
                    JSBridge.goToIndex();
                } else {
                    window.webkit.messageHandlers.goToIndex.postMessage(null);
                }
            }
            if (browser.versions.ios || browser.versions.iPhone || browser.versions.iPad) {
                $('.header-hide').hide();
                $('.content_wrap').css('top', 0);
            }
        }
    ])
    .controller("orderDetailCtrl", ["$scope", "$stateParams", "orderService", "commonService", "$window",
        function ($scope, $stateParams, orderService, commonService, $window) {
            //#regioon 订单详情
            var params = {
                orderId: $stateParams.orderId
            };
            var PenaltyAmount;
            orderService.getOrderDetail(params).then(function (res) {
                if (res && res.ReturnCode == 200) {
                    $scope.orderDetail = res.Data;
                    PenaltyAmount = res.Data.PenaltyAmount;
                    $scope.guestList = new Array();
                    //入住日期
                    var arriveDate = res.Data.ArriveDate;
                    $scope.arriveDate = arriveDate.indexOf(' ') > 0 ?
                        arriveDate.substring(0, arriveDate.indexOf(' ')) : res.Data.ArriveDate;
                    //离店日期
                    var departureDate = res.Data.DepartureDate;
                    $scope.departureDate = departureDate.indexOf(' ') > 0 ?
                        departureDate.substring(0, departureDate.indexOf(' ')) : res.Data.DepartureDate;
                    //最晚到店时间
                    var latestArriveTime = res.Data.LatestArriveTime;
                    latestArriveTime = latestArriveTime.substring(0, latestArriveTime.length - 3);
                    $scope.latestArriveTime = latestArriveTime.indexOf('T') > 0 ?
                        latestArriveTime.replace('T', ' ') : latestArriveTime;
                    //入住人姓名
                    var guestNameStr = res.Data.GuestsName;
                    if (guestNameStr && guestNameStr.indexOf(',') > 0) {
                        $scope.guestList = guestNameStr.split(',');
                    } else {
                        $scope.guestList.push(guestNameStr);
                    }
                    //订单状态
                    orderService.getOrderStatus({
                        orderId: res.Data.ElongOrderId
                    }).then(function (res) {
                        if (res && res.ReturnCode == 200 && res.Data != null) {
                            var showStatus = res.Data.ShowStatus;
                            if (showStatus == 4 || showStatus == 8 || showStatus == 16 || showStatus == 512) {
                                if (new Date(res.Data.CancelTime).getTime() < new Date().getTime()) {
                                    $scope.showStatus = commonService.convertOrderStatus(res.Data.ShowStatus);
                                    $("#div_cancelOrder>a").text("已过最晚取消时间");
                                    $("#div_cancelOrder").show();
                                    $('#div_cancelOrder>a').attr('attr', 0);
                                } else {
                                    $scope.showStatus = commonService.convertOrderStatus(res.Data.ShowStatus);
                                    $("#div_cancelOrder").show();
                                    $('#div_cancelOrder>a').attr('attr', 1);
                                }
                            }else if(showStatus == 256){
                                $scope.showStatus = commonService.convertOrderStatus(res.Data.ShowStatus);
                                $("#div_cancelOrder").hide();
                            } else {
                                $scope.showStatus = commonService.convertOrderStatus(res.Data.ShowStatus);
                                $("#div_cancelOrder").hide();
                            }
                        } else {
                            $("#div_cancelOrder").hide();
                            $scope.showStatus = commonService.convertOrderStatus(res.Data.ShowStatus);
                        }
                    });
                }
            });
            //#endregion

            //取消订单
            $scope.cancelOrder = function (orderId) {
                var attr = $('#div_cancelOrder>a').attr('attr');
                if (attr == 0) {
                    $.toast("已过最晚取消时间");
                    return false;
                }
                orderService.cancelGaranteeOrder({
                    orderId: orderId,
                    penaltyAmount: PenaltyAmount
                }).then(function (res) {
                    $.toast(res.Message);
                    if (res.ReturnCode == 200) {
                        $scope.showStatus = "订单已经取消";
                        $('#div_cancelOrder').hide();
                    }
                });
            }
            $scope.form_money = function(val){
                return Math.round(val);
            }

            //返回上一页
            $scope.backToLastPage = function () {
                var userId = localStorage.getItem(appconfig.USER_ID);
                var token = localStorage.getItem(appconfig.ACESS_TOKEN_KEY);
                if (userId != null && token != null) {
                    commonService.gotoPage("orderList", {
                        userId: userId,
                        Token: token
                    });
                } else
                    commonService.gotoPage("hotelIndex");
            }
            //查看发票详情
            $scope.goToInvoiceInfo = function(OrderCode){
                commonService.gotoPage('invoiceDetail',{
                    orderId: OrderCode
                });
            }
            //手机物理返回键处理页面跳转和模态框取消
            $window.appCloseModal = function () {
                if ($('body').has('.modal-in').length > 0) {
                    $.closeModal('.modal-in');
                } else {
                    $scope.backToLastPage();
                }
            }
            if (browser.versions.ios || browser.versions.iPhone || browser.versions.iPad) {
                $('.header-hide').hide();
                $('.content_wrap').css('top', 0);
            }
        }
    ])
    .controller("invoiceDetailCtrl",["$scope", "$stateParams", "commonService","invoiceService",
        function ($scope, $stateParams, commonService,invoiceService) {
            var params = {
                orderId: $stateParams.orderId
            };
            var OrderCode = params.orderId;
            $scope.backToDetail = function(){
                commonService.gotoPage('orderDetail',params);
            }
            invoiceService.getInvoiceInfo({OrderCode: OrderCode}).then(function (res) {
                if(res.ReturnCode == 200){
                    $scope.invoice = res.Data.invoice;
                    $scope.recipient = res.Data.recipient;
                }
            })
            if (browser.versions.ios || browser.versions.iPhone || browser.versions.iPad) {
                $('.header_hide').hide();
                $('.content_wrap').css('top', 0);
            }
        }
    ])
    .controller("registerCtrl",["$scope", "$stateParams", "registerService", "commonService","$window",
        function ($scope, $stateParams, registerService, commonService,$window) {
            $scope.getSms = function(){
                var phone = $('#phoneNum').val().trim();
                if(phone == ''){
                    $.toast("手机号码不能为空");
                    $(this).focus();
                    return false;
                }else if(!commonService.verifyMobile($.trim($("#phoneNum").val()))){
                    $.toast("请输入真实手机号");
                    $(this).focus();
                    return false;
                }
                var params = {Phone: phone};
                registerService.checkMobileExist(params).then(function (res) {
                    if(res.ReturnCode == 200){
                        if(res.Data.isExisted == "1"){
                            $.toast("手机号码已存在");
                            $(this).focus();
                            return false;
                        }else{
                            registerService.getImageCode(params).then(function (res) {
                                if(res.ReturnCode == 200){
                                    $scope.imgCode = res.Data.base64Img;
                                    $('.mask,.imgCode').show();
                                }
                            })
                        }
                    }
                });
            }
            function sms_success(){
                var second = 60;
                setInterval(function () {
                    $('.second').text(second);
                    second--;
                    if(second == -1){
                        $('.getSms').show();
                        $('#second').hide();
                        second = 60;
                        return false;
                    }
                },1000);
            }
            //更换图形验证码
            $('.input_imgCode>img').click(function () {
                var phone = $('#phoneNum').val().trim();
                registerService.getImageCode({Phone : phone}).then(function (res) {
                    if(res.ReturnCode == 200){
                        $scope.imgCode = res.Data.base64Img;
                    }
                })
            });
            //获取短信验证码，关闭图形验证码弹窗
            $scope.getSmsCode = function(){
                var params = {
                    Phone: $('#phoneNum').val().trim(),
                    Type: 'register',
                    ImgCode: $('#imgCodeInput').val().trim()
                };
                if(params.ImgCode.length != 4){
                    $.toast('验证码格式不对');
                    return false;
                }
                registerService.getPhoneCode(params).then(function (res) {
                    if(res.ReturnCode == 200){
                        $.toast(res.Message);
                        $('.imgCode,.getSms,.mask').hide();
                        $('#second').show();
                        sms_success();
                    }else{
                        $.toast(res.Message);
                        $('.input_imgCode>img').click();
                    }
                })
            }
            //注册提交
            $scope.submit_btn = function(){
                if (!validateParams()) {
                    return false;
                }
                var params = {
                    Mobile: $('#phoneNum').val().trim(),
                    Password: $('#password').val().trim(),
                    ShortCode: $('#phoneCode').val().trim(),
                    ImgCode: $('#imgCodeInput').val().trim(),
                    ApplicationType: "h5",
                    InviteCode: $stateParams.invitecode
                }
                registerService.registerSubmit(params).then(function (res) {
                    if(res.ReturnCode == 200){
                        $.toast("注册成功");
                        setTimeout(function () {
                            $window.location.href = "http://trip.org/download.html";
                        },500)
                    }else{
                        $.toast(res.Message);
                        $('.input_imgCode>img').click();
                    }
                })
            }
            function validateParams() {
                if ($.trim($("#phoneNum").val()) == "") {
                    $("#phoneNum").focus();
                    $.toast("手机号码不能为空");
                    return false;
                } else if (!commonService.verifyMobile($.trim($("#phoneNum").val()))) {
                    $.toast("请输入真实手机号");
                    return false;
                }
                if ($.trim($("#phoneCode").val()) == "") {
                    $.toast("短信验证码不能为空");
                    return false;
                }else if($.trim($("#phoneCode").val()).length != 4){
                    $.toast("短信验证码输入错误");
                    return false;
                }
                var password = $.trim($("#password").val());
                if (password == "") {
                    $.toast("密码不能为空");
                    return false;
                }
                if(password.length < 8){
                    $.toast("密码最少为8位");
                    return false;
                }else if(password.length > 20){
                    $.toast("密码设置过长");
                    return false;
                }
                var reg = new RegExp(/^[0-9a-zA-Z]+$/);
                if (!reg.test(password)){
                    $.toast("密码格式设置不正确");
                    return false;
                }
                return true;
            }
            $('.down_out').click(function () {
                $('.download').hide();
            });
            $scope.cancel_img = function () {
                $('.imgCode').hide();
                $('.mask').hide();
            }
            $scope.toProtocol = function(){
                commonService.gotoPage("protocol");
            }
        }
    ])
    .controller("guaranteeCtrl",["$scope", "$stateParams", "guaranteeService", "commonService",
        function ($scope, $stateParams,guaranteeService, commonService) {
            var params = {
                orderId: $stateParams.orderId
            };
            var TotalPrice,OrderId;
            guaranteeService.getOrderDetail(params).then(function (res) {
                if(res.ReturnCode == 200){
                    $scope.orderDetail = res.Data;
                    TotalPrice = res.Data.TotalPrice;
                    OrderId = res.Data.ElongOrderId;
                    $scope.guestList = new Array();
                    //入住日期
                    var arriveDate = res.Data.ArriveDate;
                    $scope.arriveDate = arriveDate.indexOf(' ') > 0 ?
                        arriveDate.substring(0, arriveDate.indexOf(' ')) : res.Data.ArriveDate;
                    //离店日期
                    var departureDate = res.Data.DepartureDate;
                    $scope.departureDate = departureDate.indexOf(' ') > 0 ?
                        departureDate.substring(0, departureDate.indexOf(' ')) : res.Data.DepartureDate;
                    //最晚到店时间
                    var latestArriveTime = res.Data.LatestArriveTime;
                    latestArriveTime = latestArriveTime.substring(0, latestArriveTime.length - 3);
                    $scope.latestArriveTime = latestArriveTime.indexOf('T') > 0 ?
                        latestArriveTime.replace('T', ' ') : latestArriveTime;
                    //入住人姓名
                    var guestNameStr = res.Data.GuestsName;
                    if (guestNameStr && guestNameStr.indexOf(',') > 0) {
                        $scope.guestList = guestNameStr.split(',');
                    } else {
                        $scope.guestList.push(guestNameStr);
                    }
                }
            });
            $scope.guaranteeOrder = function () {
                //登录会员id
                if (!localStorage.getItem(appconfig.USER_ID)) {
                    $.toast("未获取到登录信息，请重新登录");
                    return false;
                }
                //信用卡信息校验
                if ($("#cardNumber").val().trim() == '') {
                    $.toast("信用卡号码不能为空");
                    return false;
                }
                if($.trim($('#expiration').val()) == ''){
                    $.toast("信用卡有效期不能为空");
                    return false;
                }else if($('#expiration').val().indexOf('/') < 0){
                    $.toast("信用卡有效期格式不对");
                    return false;
                }
                if($.trim($('#cvv').val()) == ''){
                    $.toast("信用卡CVV不能为空");
                    return false;
                }
                var _post = {
                    OrderId : OrderId,
                    TotalPrice : TotalPrice,
                    CreditCard: {
                        Number: $("#cardNumber").val().trim(),
                        ExpirationYear: $("#expiration").val().split('/')[1],
                        ExpirationMonth: $("#expiration").val().split('/')[0],
                        IdType: "IdentityCard",
                        IdNo: "640302199412319552",
                        Cvv: $("#cvv").val().trim(),
                    },
                }
                guaranteeService.guaranteeSubmit(_post).then(function (res) {
                    if(res.ReturnCode == 200){
                        $.showIndicator();
                        setTimeout(function () {
                            commonService.gotoPage("orderDetail", {
                                orderId: params.orderId
                            })
                        },3000);
                    }else
                        {
                        var msg = res.Message.indexOf('|') > 0 ? res.Message.split('|')[1] : res.Message;
                        $.toast(msg);
                    }
                });
            }
            if (browser.versions.ios || browser.versions.iPhone || browser.versions.iPad) {
                $('.header-hide').hide();
                $('.android_top').hide();
            }
        }
    ])
    .controller("rulesCtrl",["$scope", "$stateParams", "commonService",
        function ($scope, $stateParams, commonService) {
            $('.rules_head>li').click(function () {
                $(".rules_head>li>a").removeClass('rule_active');
                $(this).children('a').addClass('rule_active');
                $('.rules-content>li').eq($(this).index()).show().siblings('li').hide();
            });
        }
    ])
    .controller("protocolCtrl",["$scope", "$stateParams", "commonService",
        function ($scope, $stateParams, commonService) {

        }
    ])
    .controller("inviteRuleCtrl",["$scope", "$stateParams", "commonService",
        function ($scope, $stateParams, commonService) {

        }
    ])
    .controller("communityCtrl",["$scope", "$stateParams", "commonService",
        function ($scope, $stateParams, commonService) {
            $('.copy').click(function () {
                var clipboard = new Clipboard('.copy');
                clipboard.on('success', function(e) {
                    if(e.text == '749534677'){
                        $.toast("复制成功");
                    }else if(e.text == "Triporg008"){
                        $('.gotowx,.mask').show();
                    }
                });
            })
            $scope.cancel = function () {
                $('.gotowx,.mask').hide();
            }
            $scope.goTowx = function () {
                if (browser.versions.android) {
                    JSBridge.goTowx();
                } else {
                    window.webkit.messageHandlers.goTowx.postMessage(null);
                }
            }
        }
    ])
    .controller("tokenCtrl",["$scope", "$stateParams", "commonService",
        function ($scope, $stateParams, commonService) {

        }
    ])
    .controller("introductionCtrl",["$scope", "$stateParams", "commonService",
        function ($scope, $stateParams, commonService) {

        }
    ])
    .controller("transferRulesCtrl",["$scope", "$stateParams", "commonService",
        function ($scope, $stateParams, commonService) {

        }
    ])
    .controller("rewardRuleCtrl",["$scope", "$stateParams", "commonService",
        function ($scope, $stateParams, commonService) {
            $('.reward_header').click(function () {
               $(this).parent('.reward_wrap').toggleClass('shows').siblings('.reward_wrap').removeClass('shows')})
            }
    ])
    .directive('onFinishRenderFilters', function ($timeout) {
        return {
            restrict: 'A',
            link: function (scope, element, attr) {
                if (scope.$last === true) {
                    $timeout(function () {
                        scope.$emit('ngRepeatFinished');
                    });
                }
            }
        };
    });
