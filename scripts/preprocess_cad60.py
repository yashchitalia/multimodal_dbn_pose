#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import numpy as np
import pickle as pkl


def remove_orientations_and_make_2d(joint_row):
    """As explained, this function removes all the orientation information and
    makes each 3d pose 2d. It will also remove all the confidence bits from the
    array"""
    joint_row_without_orientations = []
    for i in range(11):
        del joint_row[:10]
        joint_row_without_orientations.extend(joint_row[:3])
        del joint_row[:4]

    for i in range(4):
        joint_row_without_orientations.extend(joint_row[:3])
        del joint_row[:4] 

    joint_row_2d = []
    for i in range(15):
        x, y, z = joint_row_without_orientations[:3] 
        del joint_row_without_orientations[:3]
        X = (156.8584456124928 + 0.0976862095248 * x - 0.0006444357104 * y 
                + 0.0015715946682 * z)
        Y = (125.5357201011431 + 0.0002153447766 * x - 0.1184874093530 * y 
                - 0.0022134485957 * z)
        joint_row_2d.append([X,Y])

    return joint_row_2d


def extract_images_and_matricize_keypoints():
    """ As the title suggests the following function will modify the title of
    each file to match that of the folder in which it lies and then will also
    matricize the keypoint file associated with it """
    dat_dir = 'data/cad60_dataset'
    try: 
        joints = pkl.load(open(dat_dar+'/joints.p', 'rb')) 
    except:
        joints = []
    subdir_list = []
    for filename in os.listdir(dat_dir):
        if os.path.isdir(dat_dir+'/'+filename):
            subdir_list.append(filename)
    print subdir_list

    if not os.path.exists('data/cad60_dataset/images'):
        os.mkdir('data/cad60_dataset/images')
 
    for subdir in subdir_list:
        if not (subdir == 'images' or subdir == 'mark' or subdir == 'crop'
            or subdir == 'joint'):
            for filename in os.listdir(dat_dir+'/'+subdir):
                file_num = filename[filename.find("_")+1:filename.find(".")]
                file_type = filename[0] #R(GB) or D
                os.rename(dat_dir+'/'+subdir+'/'+filename,
                        dat_dir+'/images/'+subdir+file_num+'_'+file_type+'.jpg') 
            os.rmdir(dat_dir+'/'+subdir)

    if not (subdir == 'images' or subdir == 'mark' or subdir == 'crop'
            or subdir == 'joint'):
        for subdir in subdir_list:
            with open(dat_dir+'/'+subdir+'.txt', 'rU') as txt_file:
                lines_list = txt_file.read()
            lines_list = lines_list.split('\n')[:-1]
            for line in lines_list:
                joint_row = line.split(',')[:-1]
                if joint_row:
                    joint_row[0] = subdir+joint_row[0]
                    try:
                        joint_row[1:] = (
                            [float(joint_str) for joint_str in joint_row[1:]])
                    except ValueError:
                        print "[ERROR] Could not convert string to float"
                        print joint_row
                        return
                    joint_row[1:] = (
                            remove_orientations_and_make_2d(joint_row[1:]))
                    joints.append(joint_row)
                else:
                    continue

        pkl.dump(joints, open(dat_dir+'/joints.p', 'wb'))


if __name__ == '__main__':
    extract_images_and_matricize_keypoints()
