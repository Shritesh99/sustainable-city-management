// Code generated by protoc-gen-go. DO NOT EDIT.
// versions:
// 	protoc-gen-go v1.30.0
// 	protoc        v3.21.12
// source: bin_service/bin_service.proto

package bin_pd

import (
	protoreflect "google.golang.org/protobuf/reflect/protoreflect"
	protoimpl "google.golang.org/protobuf/runtime/protoimpl"
	reflect "reflect"
)

const (
	// Verify that this generated code is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(20 - protoimpl.MinVersion)
	// Verify that runtime/protoimpl is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(protoimpl.MaxVersion - 20)
)

var File_bin_service_bin_service_proto protoreflect.FileDescriptor

var file_bin_service_bin_service_proto_rawDesc = []byte{
	0x0a, 0x1d, 0x62, 0x69, 0x6e, 0x5f, 0x73, 0x65, 0x72, 0x76, 0x69, 0x63, 0x65, 0x2f, 0x62, 0x69,
	0x6e, 0x5f, 0x73, 0x65, 0x72, 0x76, 0x69, 0x63, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x32,
	0x0c, 0x0a, 0x0a, 0x42, 0x69, 0x6e, 0x53, 0x65, 0x72, 0x76, 0x69, 0x63, 0x65, 0x42, 0x0c, 0x5a,
	0x0a, 0x62, 0x69, 0x6e, 0x2f, 0x62, 0x69, 0x6e, 0x2d, 0x70, 0x64, 0x62, 0x06, 0x70, 0x72, 0x6f,
	0x74, 0x6f, 0x33,
}

var file_bin_service_bin_service_proto_goTypes = []interface{}{}
var file_bin_service_bin_service_proto_depIdxs = []int32{
	0, // [0:0] is the sub-list for method output_type
	0, // [0:0] is the sub-list for method input_type
	0, // [0:0] is the sub-list for extension type_name
	0, // [0:0] is the sub-list for extension extendee
	0, // [0:0] is the sub-list for field type_name
}

func init() { file_bin_service_bin_service_proto_init() }
func file_bin_service_bin_service_proto_init() {
	if File_bin_service_bin_service_proto != nil {
		return
	}
	type x struct{}
	out := protoimpl.TypeBuilder{
		File: protoimpl.DescBuilder{
			GoPackagePath: reflect.TypeOf(x{}).PkgPath(),
			RawDescriptor: file_bin_service_bin_service_proto_rawDesc,
			NumEnums:      0,
			NumMessages:   0,
			NumExtensions: 0,
			NumServices:   1,
		},
		GoTypes:           file_bin_service_bin_service_proto_goTypes,
		DependencyIndexes: file_bin_service_bin_service_proto_depIdxs,
	}.Build()
	File_bin_service_bin_service_proto = out.File
	file_bin_service_bin_service_proto_rawDesc = nil
	file_bin_service_bin_service_proto_goTypes = nil
	file_bin_service_bin_service_proto_depIdxs = nil
}
