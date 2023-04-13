// Code generated by protoc-gen-go-grpc. DO NOT EDIT.
// versions:
// - protoc-gen-go-grpc v1.2.0
// - protoc             v3.21.12
// source: airquality_service/air_service.proto

package air_pd

import (
	context "context"
	grpc "google.golang.org/grpc"
	codes "google.golang.org/grpc/codes"
	status "google.golang.org/grpc/status"
)

// This is a compile-time assertion to ensure that this generated file
// is compatible with the grpc package it is being compiled against.
// Requires gRPC-Go v1.32.0 or later.
const _ = grpc.SupportPackageIsVersion7

// AirServiceClient is the client API for AirService service.
//
// For semantics around ctx use and closing/ending streaming RPCs, please refer to https://pkg.go.dev/google.golang.org/grpc/?tab=doc#ClientConn.NewStream.
type AirServiceClient interface {
	GetAirStation(ctx context.Context, in *AirIdRequest, opts ...grpc.CallOption) (*GetAirStationResponse, error)
	GetDetailedAirData(ctx context.Context, in *NilRequest, opts ...grpc.CallOption) (*GetDetailedAirDataResponse, error)
	GetNoiseData(ctx context.Context, in *NilRequest, opts ...grpc.CallOption) (*GetNoiseDataResponse, error)
	GetPedestrianDataByTime(ctx context.Context, in *TimeRequest, opts ...grpc.CallOption) (*GetPedestrianDataResponse, error)
	GetPredictedAirData(ctx context.Context, in *NilRequest, opts ...grpc.CallOption) (*GetPredictedAirDataResponse, error)
}

type airServiceClient struct {
	cc grpc.ClientConnInterface
}

func NewAirServiceClient(cc grpc.ClientConnInterface) AirServiceClient {
	return &airServiceClient{cc}
}

func (c *airServiceClient) GetAirStation(ctx context.Context, in *AirIdRequest, opts ...grpc.CallOption) (*GetAirStationResponse, error) {
	out := new(GetAirStationResponse)
	err := c.cc.Invoke(ctx, "/AirService/GetAirStation", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *airServiceClient) GetDetailedAirData(ctx context.Context, in *NilRequest, opts ...grpc.CallOption) (*GetDetailedAirDataResponse, error) {
	out := new(GetDetailedAirDataResponse)
	err := c.cc.Invoke(ctx, "/AirService/GetDetailedAirData", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *airServiceClient) GetNoiseData(ctx context.Context, in *NilRequest, opts ...grpc.CallOption) (*GetNoiseDataResponse, error) {
	out := new(GetNoiseDataResponse)
	err := c.cc.Invoke(ctx, "/AirService/GetNoiseData", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *airServiceClient) GetPedestrianDataByTime(ctx context.Context, in *TimeRequest, opts ...grpc.CallOption) (*GetPedestrianDataResponse, error) {
	out := new(GetPedestrianDataResponse)
	err := c.cc.Invoke(ctx, "/AirService/GetPedestrianDataByTime", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *airServiceClient) GetPredictedAirData(ctx context.Context, in *NilRequest, opts ...grpc.CallOption) (*GetPredictedAirDataResponse, error) {
	out := new(GetPredictedAirDataResponse)
	err := c.cc.Invoke(ctx, "/AirService/GetPredictedAirData", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

// AirServiceServer is the server API for AirService service.
// All implementations must embed UnimplementedAirServiceServer
// for forward compatibility
type AirServiceServer interface {
	GetAirStation(context.Context, *AirIdRequest) (*GetAirStationResponse, error)
	GetDetailedAirData(context.Context, *NilRequest) (*GetDetailedAirDataResponse, error)
	GetNoiseData(context.Context, *NilRequest) (*GetNoiseDataResponse, error)
	GetPedestrianDataByTime(context.Context, *TimeRequest) (*GetPedestrianDataResponse, error)
	GetPredictedAirData(context.Context, *NilRequest) (*GetPredictedAirDataResponse, error)
	mustEmbedUnimplementedAirServiceServer()
}

// UnimplementedAirServiceServer must be embedded to have forward compatible implementations.
type UnimplementedAirServiceServer struct {
}

func (UnimplementedAirServiceServer) GetAirStation(context.Context, *AirIdRequest) (*GetAirStationResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method GetAirStation not implemented")
}
func (UnimplementedAirServiceServer) GetDetailedAirData(context.Context, *NilRequest) (*GetDetailedAirDataResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method GetDetailedAirData not implemented")
}
func (UnimplementedAirServiceServer) GetNoiseData(context.Context, *NilRequest) (*GetNoiseDataResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method GetNoiseData not implemented")
}
func (UnimplementedAirServiceServer) GetPedestrianDataByTime(context.Context, *TimeRequest) (*GetPedestrianDataResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method GetPedestrianDataByTime not implemented")
}
func (UnimplementedAirServiceServer) GetPredictedAirData(context.Context, *NilRequest) (*GetPredictedAirDataResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method GetPredictedAirData not implemented")
}
func (UnimplementedAirServiceServer) mustEmbedUnimplementedAirServiceServer() {}

// UnsafeAirServiceServer may be embedded to opt out of forward compatibility for this service.
// Use of this interface is not recommended, as added methods to AirServiceServer will
// result in compilation errors.
type UnsafeAirServiceServer interface {
	mustEmbedUnimplementedAirServiceServer()
}

func RegisterAirServiceServer(s grpc.ServiceRegistrar, srv AirServiceServer) {
	s.RegisterService(&AirService_ServiceDesc, srv)
}

func _AirService_GetAirStation_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(AirIdRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(AirServiceServer).GetAirStation(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/AirService/GetAirStation",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(AirServiceServer).GetAirStation(ctx, req.(*AirIdRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _AirService_GetDetailedAirData_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(NilRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(AirServiceServer).GetDetailedAirData(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/AirService/GetDetailedAirData",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(AirServiceServer).GetDetailedAirData(ctx, req.(*NilRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _AirService_GetNoiseData_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(NilRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(AirServiceServer).GetNoiseData(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/AirService/GetNoiseData",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(AirServiceServer).GetNoiseData(ctx, req.(*NilRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _AirService_GetPedestrianDataByTime_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(TimeRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(AirServiceServer).GetPedestrianDataByTime(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/AirService/GetPedestrianDataByTime",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(AirServiceServer).GetPedestrianDataByTime(ctx, req.(*TimeRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _AirService_GetPredictedAirData_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(NilRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(AirServiceServer).GetPredictedAirData(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/AirService/GetPredictedAirData",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(AirServiceServer).GetPredictedAirData(ctx, req.(*NilRequest))
	}
	return interceptor(ctx, in, info, handler)
}

// AirService_ServiceDesc is the grpc.ServiceDesc for AirService service.
// It's only intended for direct use with grpc.RegisterService,
// and not to be introspected or modified (even as a copy)
var AirService_ServiceDesc = grpc.ServiceDesc{
	ServiceName: "AirService",
	HandlerType: (*AirServiceServer)(nil),
	Methods: []grpc.MethodDesc{
		{
			MethodName: "GetAirStation",
			Handler:    _AirService_GetAirStation_Handler,
		},
		{
			MethodName: "GetDetailedAirData",
			Handler:    _AirService_GetDetailedAirData_Handler,
		},
		{
			MethodName: "GetNoiseData",
			Handler:    _AirService_GetNoiseData_Handler,
		},
		{
			MethodName: "GetPedestrianDataByTime",
			Handler:    _AirService_GetPedestrianDataByTime_Handler,
		},
		{
			MethodName: "GetPredictedAirData",
			Handler:    _AirService_GetPredictedAirData_Handler,
		},
	},
	Streams:  []grpc.StreamDesc{},
	Metadata: "airquality_service/air_service.proto",
}
