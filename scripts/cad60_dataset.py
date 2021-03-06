#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import numpy as np
import cv2 as cv
import pickle as pkl
import random
import scipy.io as sio

def add_random_occlusion(img_red, joint_pos, shape):
    """Add random occlusion to imitate a person with a blanket.
    Using RGB image and the position of the joints, we will arrive at a
    (partly) random rectangle that we apply to the img_reimage and then return
    it."""
    joint_unnorm = joint_pos*np.array([shape[0], shape[1]])
    min_x = int(np.min(joint_unnorm[:, 0]))
    min_y = int(np.min(joint_unnorm[:, 1]))
    max_x = int(np.max(joint_unnorm[:, 0]))
    max_y = int(np.max(joint_unnorm[:, 1]))
    #Randomize the shit out of this
    try:
        min_x = random.randint(0, min_x)
    except:
        min_x = 0
    try:
        min_y = random.randint(min_y, min_y + (max_y - min_y)/2)
    except:
        min_y = min_y
    try:
        max_x = random.randint(max_x, int(shape[0] - 1))
    except:
        max_x = int(shape[0] -1)
    try:
        max_y = random.randint(max_y, int(shape[1] - 1))
    except:
        max_y = int(shape[1] - 1)
    color = (random.randint(0, 255), random.randint(0, 255), 
            random.randint(0, 255))
    cv.rectangle(img_red, (min_x, min_y), (max_x, max_y), color,
                thickness = -1)
    return img_red

def depth_random_occlusion(img_depth, joint_pos, shape):
    """Add random occlusion to imitate the pressure map of a person.
    Using depth image and the position of the joints, we will arrive at a
    (partly) random rectangle that we apply to the img_depth image and then return
    it."""
    joint_unnorm = joint_pos*np.array([shape[0], shape[1]])
    random_joints_list = random.sample(joint_unnorm, random.randint(1, 3))
    for random_joint in random_joints_list:
        min_x = int(random_joint[0] - (shape[0]/5))
        min_y = int(random_joint[1] - (shape[1]/5))
        max_x = int(random_joint[0] + (shape[0]/5))
        max_y = int(random_joint[1] + (shape[1]/5))
        #Thresholding at zero
        if min_x < 0:
            min_x = 0
        if min_y < 0:
            min_y = 0
        #We want occlusion to be black
        color = (0, 0, 0)
        cv.rectangle(img_depth, (min_x, min_y), (max_x, max_y), color, thickness = -1)
    return img_depth


def get_roi(img_r, img_d, joint):
    nonzero_jt = []
    for j in joint:
        if np.all(j > 0):
            nonzero_jt.append(j)
    nonzero_jt = np.asarray(nonzero_jt)

    min_x = int(np.min(nonzero_jt[:, 0]))
    min_y = int(np.min(nonzero_jt[:, 1]))
    max_x = int(np.max(nonzero_jt[:, 0]))
    max_y = int(np.max(nonzero_jt[:, 1]))

    width = (max_x - min_x)
    height = (max_y - min_y)
    ext_width = width * 2
    ext_height = height * 2

    st_y = min_y + height / 2 - ext_height / 2
    st_y = st_y if st_y > 0 else 0

    en_y = min_y + height / 2 + ext_height / 2
    en_y = en_y if en_y < img_r.shape[0] else img_r.shape[0]

    st_x = min_x + width / 2 - ext_width / 2
    st_x = st_x if st_x > 0 else 0

    en_x = min_x + width / 2 + ext_width / 2
    en_x = en_x if en_x < img_r.shape[1] else img_r.shape[1]
    img_r = img_r[st_y:en_y, st_x:en_x]
    img_d = img_d[st_y:en_y, st_x:en_x]
    return img_r, img_d, (st_x, st_y), (en_x - st_x, en_y - st_y)


def get_target_joints(joint, lt, shape):
    joint_pos = np.asarray(joint).reshape((15, 2))
    joint_pos -= np.array([lt[0], lt[1]])
    joint_pos /= np.array([shape[0], shape[1]])
    return joint_pos


def save_crop_images_and_joints():
    jnt_fn = 'data/cad60_dataset/joints.p'
    joints = pkl.load(open(jnt_fn, 'rb'))
    if not os.path.exists('data/cad60_dataset/crop'):
        os.mkdir('data/cad60_dataset/crop')
    if not os.path.exists('data/cad60_dataset/mark'):
        os.mkdir('data/cad60_dataset/mark')
    if not os.path.exists('data/cad60_dataset/joint'):
        os.mkdir('data/cad60_dataset/joint')

    img_dir = 'data/cad60_dataset/images'
    #To store in matlab
    rgb_image_mat = []
    rgb_occ_mat = []
    d_image_mat = []
    d_occ_mat = []
    mat_joints = []

    for joint in joints:
        img_r = cv.imread(img_dir+'/'+ joint[0] + '_R.jpg')
        img_d = cv.imread(img_dir+'/'+ joint[0] + '_D.jpg',cv.IMREAD_UNCHANGED)	#~NA preserve format of image
        img_d = 255.0*img_d/(img_d.max())#~NA Normalize image
        print joint[0]
        img_r, img_d, lt, shape = get_roi(img_r, img_d, joint[1:])
        joint_pos = get_target_joints(joint[1:], lt, shape)
        img_occ = add_random_occlusion(img_r.copy(), joint_pos, shape)
        d_occ = depth_random_occlusion(img_d.copy(), joint_pos, shape)

        if np.all(joint_pos > 0):
            img_r = cv.resize(img_r, (60, 90))
            img_d = cv.resize(img_d, (60, 90))
            img_occ = cv.resize(img_occ, (60, 90))
            d_occ = cv.resize(d_occ, (60, 90))
            #cv.imwrite('data/cad60_dataset/crop/'+joint[0]+'_R.jpg', img_r)
            #cv.imwrite('data/cad60_dataset/crop/'+joint[0]+'_D.jpg', d_occ)
            cv.imwrite('data/cad60_dataset/crop/'+joint[0]+'_OCC.jpg', img_occ)

            #Flatten the RGB original(and resized) image to be stored as mat file
            img_r = cv.cvtColor(img_r, cv.COLOR_BGR2GRAY)
            array_img_r = np.array(img_r)
            flat_img_r = np.ravel(array_img_r)
            rgb_image_mat.append(list(flat_img_r))


            #Flatten the RGB occluded image to be stored as mat file
            img_occ = cv.cvtColor(img_occ, cv.COLOR_BGR2GRAY)
            array_img_occ = np.array(img_occ)
            flat_img_occ = np.ravel(array_img_occ)
            rgb_occ_mat.append(list(flat_img_occ))

            #Flatten the D image to be stored as mat file
            #img_d = cv.cvtColor(img_d, cv.COLOR_BGR2GRAY)#~NA no need
            array_img_d = np.array(img_d)
            flat_img_d = np.uint8(np.round(np.ravel(array_img_d)))#~NA convert to integer
            d_image_mat.append(list(flat_img_d))

            #Flatten the D image to be stored as mat file
            #d_occ = cv.cvtColor(d_occ, cv.COLOR_BGR2GRAY)#~NA no need
            array_d_occ = np.array(d_occ)
            flat_d_occ = np.uint8(np.round(np.ravel(array_d_occ)))#~NA convert to integer
            d_occ_mat.append(list(flat_d_occ))
            
            for j in joint_pos:
                p = (int(j[0] * 60), int(j[1] * 90))
                cv.circle(img_r, p, 3, (0, 0, 255), -1)
            #cv.imwrite('data/cad60_dataset/mark/'+joint[0]+'_R.jpg', img_r)
            joint_pos_flat = joint_pos.flatten()
            #np.save('data/cad60_dataset/joint/'+joint[0], joint_pos_flat)

            chain_mix = list(joint_pos_flat)
            chain = [int(joint[0])] + chain_mix
            mat_joints.append(chain)
 
    sio.savemat('data/cad60_dataset/rgb_orig.mat', {'rgb_orig':rgb_image_mat})#Store as mat
    sio.savemat('data/cad60_dataset/rgb_occ.mat', {'rgb_occ':rgb_occ_mat})#Store as mat
    sio.savemat('data/cad60_dataset/d_orig.mat', {'d_orig':d_image_mat})#Store as mat
    sio.savemat('data/cad60_dataset/d_occ.mat', {'d_occ':d_occ_mat})#Store as mat
    sio.savemat('data/cad60_dataset/joints_orig.mat', {'joints_orig':mat_joints})#Store as mat

if __name__ == '__main__':
    save_crop_images_and_joints()
