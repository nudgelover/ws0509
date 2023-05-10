<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--jquery--%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<style>
    #map {
        width: 400px;
        height: 400px;
        border: 2px solid red;
    }

    #update_btn, #delete_btn {
        margin-left: 30%;
        max-width: 40%;

    }

    #markerimg {
        width: 100%;
        height: 100%;
        max-width: 300px;
        max-height: 300px;
    }

    #preview_box {
        margin: 5% 35%;
    }

    #preview {
        width: 100%;
        height: 100%;
    }
</style>
<script>
    let marker_detail_map = {
        map : null,
        init: function () {
            var mapContainer = document.querySelector('#map');
            var mapOption = {
                center: new kakao.maps.LatLng(${markerinfo.lat}, ${markerinfo.lng}), // ������ �߽���ǥ
                level : 3 // ������ Ȯ�� ��
            };
            map = new kakao.maps.Map(mapContainer, mapOption);
            var mapTypeControl = new kakao.maps.MapTypeControl();

            // ������ ��Ʈ���� �߰��ؾ� �������� ǥ�õ˴ϴ�
            // kakao.maps.ControlPosition�� ��Ʈ���� ǥ�õ� ��ġ�� �����ϴµ� TOPRIGHT�� ������ ���� �ǹ��մϴ�
            map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);

            // ���� Ȯ�� ��Ҹ� ������ �� �ִ�  �� ��Ʈ���� �����մϴ�
            var zoomControl = new kakao.maps.ZoomControl();
            map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

            var markerPosition = new kakao.maps.LatLng(${markerinfo.lat}, ${markerinfo.lng});

            // ��Ŀ�� �����մϴ�
            var marker = new kakao.maps.Marker({
                position: markerPosition
            });

            // ��Ŀ�� ���� ���� ǥ�õǵ��� �����մϴ�
            marker.setMap(map);
            // ��Ŀ�� Ŀ���� �������� �� ��Ŀ ���� ǥ���� ���������츦 �����մϴ�
            var iwContent = '<img src="/uimg/${markerinfo.img}" style="width: 150px"><div style="padding:5px;">${markerinfo.title}</div>'; // ���������쿡 ǥ��� �������� HTML ���ڿ��̳� document element�� �����մϴ�

            // ���������츦 �����մϴ�
            var infowindow = new kakao.maps.InfoWindow({
                content: iwContent
            });

// ��Ŀ�� ���콺���� �̺�Ʈ�� ����մϴ�
            kakao.maps.event.addListener(marker, 'mouseover', function () {
                // ��Ŀ�� ���콺���� �̺�Ʈ�� �߻��ϸ� ���������츦 ��Ŀ���� ǥ���մϴ�
                infowindow.open(map, marker);
            });

// ��Ŀ�� ���콺�ƿ� �̺�Ʈ�� ����մϴ�
            kakao.maps.event.addListener(marker, 'mouseout', function () {
                // ��Ŀ�� ���콺�ƿ� �̺�Ʈ�� �߻��ϸ� ���������츦 �����մϴ�
                infowindow.close();
            });

            kakao.maps.event.addListener(marker, 'click', function () {
                location.href = '${markerinfo.target}';
            });
        }
    };
    let marker_detail = {
        init: function () {
            $('#update_btn').click(function () {
                marker_detail.send();
            });
            $('#delete_btn').click(function () {
                var c = confirm("�����Ͻðڽ��ϱ�?");
                if (c == true) {
                    location.href = "/marker/deleteimpl?id=${markerinfo.id}";
                }
            });
        },
        send: function () {
            $('#marker_detail_form').attr({
                method : 'post',
                action : '/marker/updateimpl',
                enctype: 'multipart/form-data'
            });
            $('#marker_detail_form').submit();
        },
    }
    $(function () {
        marker_detail_map.init();
        marker_detail.init();
    });
</script>
<script>
    function readURL(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function (e) {
                document.getElementById('preview').src = e.target.result;
            };
            reader.readAsDataURL(input.files[0]);
        } else {
            document.getElementById('preview').src = "";
        }
    }
</script>
<div class="container-fluid">

    <!-- Page Heading -->
    <h1 class="h3 mb-2 text-gray-800">Marker Detail</h1>
    <p class="mb-4">Marker ���������Դϴ�.</p>

    <!-- DataTales Example -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">marker : ${markerinfo.title}</h6>
        </div>
        <div class="card-body">
            <figure class="highcharts-figure text-center">

                <p><img id="markerimg" data-toggle="modal" data-target="#img${markerinfo.id}"
                        src="/uimg/${markerinfo.img}"></p>


                <h2>${markerinfo.title}</h2>

                <form id="marker_detail_form" class="user">
                    <input type="hidden" id="id" name="id" value="${markerinfo.id}">
                    <input type="hidden" id="img" name="img" value="${markerinfo.img}">
                    <div class="form-group">
                        <input type="title" class="form-control form-control-user" id="title" name="title"
                               value="${markerinfo.title}">
                    </div>
                    <div class="form-group">
                        <input type="text" class="form-control form-control-user" id="target" name="target"
                               value="${markerinfo.target}">
                    </div>
                    <div class="form-group">
                        <input type="number" class="form-control form-control-user" id="lat" name="lat"
                               value="${markerinfo.lat}">
                    </div>
                    <div class="form-group">
                        <input type="number" class="form-control form-control-user" id="lng" name="lng"
                               value="${markerinfo.lng}">
                    </div>
                    <div class="form-group">
                        <input type="text" class="form-control form-control-user" id="loc" name="loc"
                               value="${markerinfo.loc}">
                    </div>
                    <div class="form-group">
                        <input type="file" class="form-control form-control-user"
                               id="file" name="file" onchange="readURL(this)" placeholder="Input image">
                        <div id="preview_box"><img id="preview"/></div>
                    </div>


                    <hr>

                    <button type="button" id="update_btn" class="btn btn-primary btn-user btn-block">Update Info
                    </button>
                    <button type="button" id="delete_btn" class="btn btn-primary btn-user btn-block">Delete Info
                    </button>


                </form>


            </figure>
            <div class="card-body">
                <div class="row ">
                    <div class="col-sm-10" id="map"></div>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
</div>

